const Transaction = require("../../database/models/Transaction");

const getMyTransactions = async (req, res) => {
    try {
        const transactions = await Transaction.find({ userId: req.user._id })
            .sort({ createdAt: -1 })
            .limit(100);
        return res.status(200).json({
            message: "Transaction history fetched",
            count: transactions.length,
            transactions
        });
    } catch (error) {
        return res.status(500).json({ message: "Failed to fetch transactions" });
    }
};

module.exports = { getMyTransactions };
