/**
 * ============================================
 * 💰 AFRICORE OS - WALLET SERVICE
 * ============================================
 * Handles all wallet business logic
 */

const Wallet = require("../../database/models/Wallet");

// =============================
// CREATE WALLET (AUTO ON USER REGISTER)
// =============================
const createWallet = async (userId) => {
    const existingWallet = await Wallet.findOne({ userId });

    if (existingWallet) {
        return existingWallet;
    }

    const wallet = await Wallet.create({
        userId,
        balance: 0,
        currency: "NGN"
    });

    return wallet;
};

// =============================
// GET WALLET BALANCE
// =============================
const getBalance = async (userId) => {
    const wallet = await Wallet.findOne({ userId });

    if (!wallet) {
        throw new Error("Wallet not found");
    }

    return {
        balance: wallet.balance,
        currency: wallet.currency
    };
};

// =============================
// CREDIT WALLET (ADD MONEY)
// =============================
const creditWallet = async (userId, amount) => {
    if (amount <= 0) {
        throw new Error("Invalid amount");
    }

    const wallet = await Wallet.findOne({ userId });

    if (!wallet) {
        throw new Error("Wallet not found");
    }

    wallet.balance += amount;
    await wallet.save();

    return {
        message: "Wallet credited successfully",
        newBalance: wallet.balance
    };
};

// =============================
// DEBIT WALLET (REMOVE MONEY)
// =============================
const debitWallet = async (userId, amount) => {
    if (amount <= 0) {
        throw new Error("Invalid amount");
    }

    const wallet = await Wallet.findOne({ userId });

    if (!wallet) {
        throw new Error("Wallet not found");
    }

    if (wallet.balance < amount) {
        throw new Error("Insufficient balance");
    }

    wallet.balance -= amount;
    await wallet.save();

    return {
        message: "Wallet debited successfully",
        newBalance: wallet.balance
    };
};

// =============================
// EXPORT SERVICES
// =============================
module.exports = {
    createWallet,
    getBalance,
    creditWallet,
    debitWallet
};
