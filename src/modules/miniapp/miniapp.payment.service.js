const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const { checkFraud } = require("../security/fraud.service");
const MiniApp = require("../../database/models/MiniApp");
const Wallet = require("../../database/models/Wallet");
const Transaction = require("../../database/models/Transaction");
const calculateFee = require("../../utils/feeCalculator");

const PLATFORM_OWNER_ID = process.env.PLATFORM_OWNER_ID;

const processMiniAppPayment = async ({
    userId,
    appId,
    amount,
    description
}) => {
    const numericAmount = Number(amount);
    if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
        throw new Error("Enter a valid positive amount.");
    }
    if (!PLATFORM_OWNER_ID) {
        throw new Error("Mini-app payments are not enabled: platform wallet is not configured.");
    }

    const app = await MiniApp.findById(appId);
    if (!app || !app.isActive) throw new Error("Mini app is not available.");
    if (!app.permissions?.walletAccess) throw new Error("This mini app is not allowed to use wallet payments.");
    if (!app.developerId) throw new Error("This mini app has no registered developer wallet.");

    const { fee, developerAmount } = calculateFee(numericAmount);
    if (!Number.isFinite(fee) || !Number.isFinite(developerAmount) ||
        fee < 0 || developerAmount <= 0) {
        throw new Error("Payment amount is below the minimum supported amount.");
    }

    await checkFraud({ userId, amount: numericAmount });

    const session = await mongoose.startSession();
    let newBalance;
    const reference = `miniapp_${uuidv4()}`;

    try {
        session.startTransaction();
        const ownerIds = [...new Set([
            String(userId),
            String(app.developerId),
            String(PLATFORM_OWNER_ID)
        ])];

        const wallets = await Wallet.find({
            userId: { $in: ownerIds }
        }).session(session);
        const walletByOwner = new Map(
            wallets.map((wallet) => [String(wallet.userId), wallet])
        );

        const payerWallet = walletByOwner.get(String(userId));
        const developerWallet = walletByOwner.get(String(app.developerId));
        const platformWallet = walletByOwner.get(String(PLATFORM_OWNER_ID));
        if (!payerWallet || !developerWallet || !platformWallet) {
            throw new Error("A required mini-app wallet has not been initialized.");
        }
        if (Number(payerWallet.balance || 0) < numericAmount) {
            throw new Error("Insufficient wallet balance.");
        }

        payerWallet.balance = Number(payerWallet.balance || 0) - numericAmount;
        developerWallet.balance = Number(developerWallet.balance || 0) + developerAmount;
        platformWallet.balance = Number(platformWallet.balance || 0) + fee;
        newBalance = payerWallet.balance;

        await Promise.all([...new Set([payerWallet, developerWallet, platformWallet])]
            .map((wallet) => wallet.save({ session })));

        const memo = String(description || `${app.name} payment`).slice(0, 180);
        await Transaction.create([
            {
                userId,
                walletId: payerWallet._id,
                type: "debit",
                amount: numericAmount,
                status: "successful",
                reference: `${reference}_debit`,
                description: memo,
                provider: "miniapp"
            },
            {
                userId: app.developerId,
                walletId: developerWallet._id,
                type: "credit",
                amount: developerAmount,
                status: "successful",
                reference: `${reference}_developer`,
                description: `Developer earnings: ${app.name}`,
                provider: "miniapp"
            },
            {
                userId: PLATFORM_OWNER_ID,
                walletId: platformWallet._id,
                type: "credit",
                amount: fee,
                status: "successful",
                reference: `${reference}_platform`,
                description: `Platform fee: ${app.name}`,
                provider: "platform-fee"
            }
        ], { session });

        await session.commitTransaction();
    } catch (error) {
        if (session.inTransaction()) await session.abortTransaction();
        throw error;
    } finally {
        await session.endSession();
    }

    try {
        const { sendNotification } = require("../notifications/notification.service");
        await sendNotification({
            userId,
            title: "Payment successful",
            message: `You paid ₦${numericAmount} for ${app.name}`,
            type: "payment"
        });
    } catch (error) {
        console.error("Mini-app payment committed; notification failed:", error.message);
    }

    return {
        message: "Payment successful",
        reference,
        totalPaid: numericAmount,
        fee,
        developerReceived: developerAmount,
        newBalance
    };
};

module.exports = { processMiniAppPayment };
