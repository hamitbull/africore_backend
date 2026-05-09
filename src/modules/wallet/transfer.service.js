/**
 * ============================================
 * 💸 AFRICORE OS - TRANSFER SERVICE
 * ============================================
 * Handles user-to-user money transfer
 */
const { checkFraud } = require("../security/fraud.service");
const User = require("../../database/models/User");

// Ledger
const {
    creditWalletWithLedger,
    debitWalletWithLedger
} = require("./ledger.service");

// =============================
// TRANSFER MONEY
// =============================
const transferMoney = async ({ senderId, receiverAfroId, amount }) => {
    if (!receiverAfroId || !amount) {
        throw new Error("Receiver and amount required");
    }

    if (amount <= 0) {
        throw new Error("Invalid amount");
    }

    // Find receiver
    const receiver = await User.findOne({ afro_id: receiverAfroId });

    if (!receiver) {
        throw new Error("Receiver not found");
    }

    if (receiver._id.toString() === senderId) {
        throw new Error("Cannot transfer to yourself");
    }

    await checkFraud({
    userId: senderId,
    amount
});

    // =============================
    // 💸 DEBIT SENDER
    // =============================
    const debitResult = await debitWalletWithLedger({
        userId: senderId,
        amount,
        description: `Transfer to ${receiverAfroId}`,
        provider: "africore-transfer"
    });
    
    const { sendNotification } = require("../notifications/notification.service");

// Sender
await sendNotification({
    userId: senderId,
    title: "Transfer Sent",
    message: `You sent ₦${amount} to ${receiverAfroId}`,
    type: "transfer"
});

// Receiver
await sendNotification({
    userId: receiver._id,
    title: "Money Received",
    message: `You received ₦${amount}`,
    type: "transfer"
});

    // =============================
    // 💰 CREDIT RECEIVER
    // =============================
    const creditResult = await creditWalletWithLedger({
        userId: receiver._id,
        amount,
        description: `Received from transfer`,
        provider: "africore-transfer"
    });

    return {
        message: "Transfer successful",
        amount,
        senderBalance: debitResult.newBalance,
        receiver: {
            name: receiver.name,
            afro_id: receiver.afro_id
        }
    };
};

// =============================
// EXPORT
// =============================
module.exports = {
    transferMoney
};
