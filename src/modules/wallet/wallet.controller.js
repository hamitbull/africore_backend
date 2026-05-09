/**
 * ============================================
 * 💰 AFRICORE OS - WALLET CONTROLLER
 * ============================================
 * Handles wallet API requests & responses
 */

const {
    createWallet,
    getBalance,
    creditWallet,
    debitWallet
} = require("./wallet.service");

// =============================
// CREATE WALLET (internal use)
// =============================
const createUserWallet = async (req, res) => {
    try {
        const { userId } = req.body;

        const wallet = await createWallet(userId);

        return res.status(201).json({
            message: "Wallet created successfully",
            wallet
        });

    } catch (error) {
        console.error("❌ CREATE WALLET ERROR:", error.message);

        return res.status(500).json({
            message: error.message
        });
    }
};

// =============================
// GET BALANCE
// =============================
const getWalletBalance = async (req, res) => {
    try {
        const { userId } = req.params;

        const balance = await getBalance(userId);

        return res.json({
            message: "Wallet balance fetched",
            data: balance
        });

    } catch (error) {
        console.error("❌ GET BALANCE ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// CREDIT WALLET
// =============================
const creditUserWallet = async (req, res) => {
    try {
        const { userId, amount } = req.body;

        const result = await creditWallet(userId, amount);

        return res.json(result);

    } catch (error) {
        console.error("❌ CREDIT ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// DEBIT WALLET
// =============================
const debitUserWallet = async (req, res) => {
    try {
        const { userId, amount } = req.body;

        const result = await debitWallet(userId, amount);

        return res.json(result);

    } catch (error) {
        console.error("❌ DEBIT ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// EXPORT CONTROLLER
// =============================
module.exports = {
    createUserWallet,
    getWalletBalance,
    creditUserWallet,
    debitUserWallet
};
