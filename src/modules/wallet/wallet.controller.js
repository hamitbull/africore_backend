const {
    createWallet,
    getBalance,
    creditWallet,
    debitWallet
} = require("./wallet.service");
const User = require("../../database/models/User");
const Transaction = require("../../database/models/Transaction");

const createUserWallet = async (req, res) => {
    try {
        const { userId } = req.body;
        if (!userId) return res.status(400).json({ message: "userId is required" });
        const wallet = await createWallet(userId);
        return res.status(201).json({ message: "Wallet created successfully", wallet });
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

const getMyWallet = async (req, res) => {
    try {
        const userId = req.user._id;
        const [balance, user, transactions] = await Promise.all([
            getBalance(userId),
            User.findById(userId).select("virtualAccount name afro_id"),
            Transaction.find({ userId }).sort({ createdAt: -1 }).limit(20)
        ]);
        return res.status(200).json({
            wallet: balance,
            user: user ? {
                name: user.name,
                afro_id: user.afro_id,
                virtualAccount: user.virtualAccount || null
            } : null,
            transactions
        });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
};

const creditUserWallet = async (req, res) => {
    try {
        const { userId, amount } = req.body;
        if (!userId) return res.status(400).json({ message: "userId is required" });
        return res.json(await creditWallet(userId, amount));
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

const debitUserWallet = async (req, res) => {
    try {
        const { userId, amount } = req.body;
        if (!userId) return res.status(400).json({ message: "userId is required" });
        return res.json(await debitWallet(userId, amount));
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

module.exports = { createUserWallet, getMyWallet, creditUserWallet, debitUserWallet };
