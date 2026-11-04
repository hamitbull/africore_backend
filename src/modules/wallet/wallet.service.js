const Wallet = require("../../database/models/Wallet");
const {
    creditWalletWithLedger,
    debitWalletWithLedger
} = require("./ledger.service");

const createWallet = async (userId) => {
    if (!userId) throw new Error("userId is required.");
    const existingWallet = await Wallet.findOne({ userId });
    if (existingWallet) return existingWallet;

    try {
        return await Wallet.create({
            userId,
            balance: 0,
            currency: "NGN"
        });
    } catch (error) {
        // A concurrent registration may have created the unique wallet first.
        if (error.code === 11000) {
            const wallet = await Wallet.findOne({ userId });
            if (wallet) return wallet;
        }
        throw error;
    }
};

const getBalance = async (userId) => {
    const wallet = await Wallet.findOne({ userId });
    if (!wallet) throw new Error("Wallet not found.");
    return {
        balance: Number(wallet.balance || 0),
        currency: wallet.currency || "NGN"
    };
};

// These administrative adjustments still go through the same auditable ledger.
const creditWallet = async (userId, amount) => creditWalletWithLedger({
    userId,
    amount,
    description: "Administrative wallet credit",
    provider: "admin-adjustment"
});

const debitWallet = async (userId, amount) => debitWalletWithLedger({
    userId,
    amount,
    description: "Administrative wallet debit",
    provider: "admin-adjustment"
});

module.exports = { createWallet, getBalance, creditWallet, debitWallet };
