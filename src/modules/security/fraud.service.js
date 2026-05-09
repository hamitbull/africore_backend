/**
const FraudLog = require("../../database/models/FraudLog"); * ==============
 * ============================================
 */

const FraudLog = require("../../database/models/FraudLog");
const Transaction = require("../../database/models/Transaction");
const User = require("../../database/models/User");

const FRAUD_LIMITS = {
    MAX_SINGLE_TRANSACTION: 500000, // ₦500k
    MAX_DAILY_AMOUNT: 1000000,      // ₦1M
    MAX_TX_PER_MINUTE: 5
};

// =============================
// MAIN FRAUD CHECK
// =============================
const checkFraud = async ({ userId, amount }) => {

    // 🚨 Rule 1: Single large transaction
    if (amount > FRAUD_LIMITS.MAX_SINGLE_TRANSACTION) {
await FraudLog.create({
    userId,
    amount,
    reason: "Daily limit exceeded"
});
        throw new Error("Transaction too large (Fraud suspected)");
    }

    // 🚨 Rule 2: Daily limit
    const today = new Date();
    today.setHours(0,0,0,0);

    const dailyTx = await Transaction.aggregate([
        {
            $match: {
                userId,
                createdAt: { $gte: today },
                status: "successful"
            }
        },
        {
            $group: {
                _id: null,
                total: { $sum: "$amount" }
            }
        }
    ]);

    const totalToday = dailyTx[0]?.total || 0;

    if ((totalToday + amount) > FRAUD_LIMITS.MAX_DAILY_AMOUNT) {
        throw new Error("Daily transaction limit exceeded");
    }

    // 🚨 Rule 3: Too many transactions quickly
    const oneMinuteAgo = new Date(Date.now() - 60 * 1000);

    const recentTxCount = await Transaction.countDocuments({
        userId,
        createdAt: { $gte: oneMinuteAgo }
    });

    if (recentTxCount >= FRAUD_LIMITS.MAX_TX_PER_MINUTE) {
        throw new Error("Too many transactions (possible bot)");
    }

    // 🚨 Rule 4: New user high spending
    const user = await User.findById(userId);

    const accountAge = (Date.now() - new Date(user.createdAt)) / (1000 * 60 * 60);

    if (accountAge < 24 && amount > 100000) {
        throw new Error("New account high-risk transaction blocked");
    }

    return true;
};

module.exports = {
    checkFraud
};
