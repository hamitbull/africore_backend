/**
 * ============================================
 * 📊 AFRICORE OS - TRANSACTION CONTROLLER
 * ============================================
 * Handles transaction history API
 */

const Transaction = require("../../database/models/Transaction");

// =============================
// GET USER TRANSACTIONS
// =============================
const getUserTransactions = async (req, res) => {
    try {
        const { userId } = req.params;

        const transactions = await Transaction.find({ userId })
            .sort({ createdAt: -1 });

        return res.json({
            message: "Transaction history fetched",
            count: transactions.length,
            data: transactions
        });

    } catch (error) {
        console.error("❌ TRANSACTION FETCH ERROR:", error.message);

        return res.status(500).json({
            message: "Failed to fetch transactions"
        });
    }
};

// =============================
// EXPORT
// =============================
module.exports = {
    getUserTransactions
};
