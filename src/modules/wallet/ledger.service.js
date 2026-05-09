/**
 * ============================================
 * 🧠 AFRICORE OS - LEDGER SERVICE
 * ============================================
 * Ensures safe & atomic financial transactions
 */

const mongoose = require("mongoose");
const Wallet = require("../../database/models/Wallet");
const Transaction = require("../../database/models/Transaction");
const { v4: uuidv4 } = require("uuid");

// =============================
// CREDIT WITH TRANSACTION LOG
// =============================
const creditWalletWithLedger = async ({ userId, amount, description, provider = "africore" }) => {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
        const wallet = await Wallet.findOne({ userId }).session(session);

        if (!wallet) {
            throw new Error("Wallet not found");
        }

        const reference = `txn_${uuidv4()}`;

        // Create transaction (pending)
        const transaction = await Transaction.create([{
            userId,
            walletId: wallet._id,
            type: "credit",
            amount,
            status: "pending",
            reference,
            description,
            provider
        }], { session });

        // Update wallet balance
        wallet.balance += amount;
        await wallet.save({ session });

        // Mark transaction as successful
        transaction[0].status = "successful";
        await transaction[0].save({ session });

        await session.commitTransaction();
        session.endSession();

        return {
            message: "Wallet credited successfully",
            amount,
            newBalance: wallet.balance,
            reference
        };

    } catch (error) {
        await session.abortTransaction();
        session.endSession();

        console.error("❌ LEDGER CREDIT ERROR:", error.message);
        throw new Error("Transaction failed");
    }
};

// =============================
// DEBIT WITH TRANSACTION LOG
// =============================
const debitWalletWithLedger = async ({ userId, amount, description, provider = "africore" }) => {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
        const wallet = await Wallet.findOne({ userId }).session(session);

        if (!wallet) {
            throw new Error("Wallet not found");
        }

        if (wallet.balance < amount) {
            throw new Error("Insufficient balance");
        }

        const reference = `txn_${uuidv4()}`;

        // Create transaction (pending)
        const transaction = await Transaction.create([{
            userId,
            walletId: wallet._id,
            type: "debit",
            amount,
            status: "pending",
            reference,
            description,
            provider
        }], { session });

        // Deduct balance
        wallet.balance -= amount;
        await wallet.save({ session });

        // Mark transaction successful
        transaction[0].status = "successful";
        await transaction[0].save({ session });

        await session.commitTransaction();
        session.endSession();

        return {
            message: "Wallet debited successfully",
            amount,
            newBalance: wallet.balance,
            reference
        };

    } catch (error) {
        await session.abortTransaction();
        session.endSession();

        console.error("❌ LEDGER DEBIT ERROR:", error.message);
        throw new Error("Transaction failed");
    }
};

// =============================
// EXPORT
// =============================
module.exports = {
    creditWalletWithLedger,
    debitWalletWithLedger
};
