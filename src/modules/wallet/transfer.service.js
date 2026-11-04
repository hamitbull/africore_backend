const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const { checkFraud } = require("../security/fraud.service");
const User = require("../../database/models/User");
const Wallet = require("../../database/models/Wallet");
const Transaction = require("../../database/models/Transaction");

const transferMoney = async ({ senderId, receiverAfroId, amount }) => {
    const numericAmount = Number(amount);
    if (!receiverAfroId || !Number.isFinite(numericAmount) || numericAmount <= 0) {
        throw new Error("A receiver and a valid positive amount are required.");
    }

    const sender = await User.findById(senderId);
    if (!sender) throw new Error("Sender account not found.");
    const receiver = await User.findOne({ afro_id: String(receiverAfroId).trim() });
    if (!receiver) throw new Error("Receiver not found.");
    if (receiver._id.toString() === sender._id.toString()) {
        throw new Error("You cannot transfer money to yourself.");
    }

    await checkFraud({ userId: sender._id, amount: numericAmount });

    const session = await mongoose.startSession();
    let senderBalance;
    let reference;

    try {
        session.startTransaction();
        const senderWallet = await Wallet.findOne({ userId: sender._id }).session(session);
        const receiverWallet = await Wallet.findOne({ userId: receiver._id }).session(session);

        if (!senderWallet || !receiverWallet) throw new Error("Wallet not found.");
        if (Number(senderWallet.balance || 0) < numericAmount) {
            throw new Error("Insufficient balance.");
        }

        reference = `transfer_${uuidv4()}`;
        senderWallet.balance = Number(senderWallet.balance || 0) - numericAmount;
        receiverWallet.balance = Number(receiverWallet.balance || 0) + numericAmount;

        await Promise.all([
            senderWallet.save({ session }),
            receiverWallet.save({ session })
        ]);

        await Transaction.create([
            {
                userId: sender._id,
                walletId: senderWallet._id,
                type: "debit",
                amount: numericAmount,
                status: "successful",
                reference: `${reference}_out`,
                description: `Transfer to ${receiver.afro_id}`,
                provider: "africore-transfer"
            },
            {
                userId: receiver._id,
                walletId: receiverWallet._id,
                type: "credit",
                amount: numericAmount,
                status: "successful",
                reference: `${reference}_in`,
                description: `Transfer from ${sender.afro_id}`,
                provider: "africore-transfer"
            }
        ], { session });

        senderBalance = senderWallet.balance;
        await session.commitTransaction();
    } catch (error) {
        if (session.inTransaction()) await session.abortTransaction();
        throw error;
    } finally {
        await session.endSession();
    }

    // Notifications are sent after the ledger commit. A notification outage must
    // never reverse or interrupt an already completed money transfer.
    try {
        const { sendNotification } = require("../notifications/notification.service");
        await Promise.all([
            sendNotification({
                userId: sender._id,
                title: "Transfer sent",
                message: `You sent ₦${numericAmount} to ${receiver.afro_id}`,
                type: "transfer"
            }),
            sendNotification({
                userId: receiver._id,
                title: "Money received",
                message: `You received ₦${numericAmount} from ${sender.afro_id}`,
                type: "transfer"
            })
        ]);
    } catch (notificationError) {
        console.error("Transfer committed; notification delivery failed:", notificationError.message);
    }

    return {
        message: "Transfer successful",
        reference,
        amount: numericAmount,
        senderBalance,
        receiver: { name: receiver.name, afro_id: receiver.afro_id }
    };
};

module.exports = { transferMoney };
