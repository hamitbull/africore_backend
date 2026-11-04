const mongoose = require("mongoose");
const Wallet = require("../../database/models/Wallet");
const Transaction = require("../../database/models/Transaction");
const { v4: uuidv4 } = require("uuid");

const validAmount = (value) => {
    const amount = Number(value);
    if (!Number.isFinite(amount) || amount <= 0) {
        throw new Error("Amount must be a positive finite number.");
    }
    return amount;
};

const creditWalletWithLedger = async ({
    userId,
    amount,
    description,
    provider = "africore",
    reference
}) => {
    const numericAmount = validAmount(amount);
    const txReference = reference || `txn_${uuidv4()}`;
    const session = await mongoose.startSession();

    try {
        session.startTransaction();
        const wallet = await Wallet.findOne({ userId }).session(session);
        if (!wallet) throw new Error("Wallet not found.");

        let transaction = await Transaction.findOne({ reference: txReference }).session(session);
        if (transaction) {
            if (String(transaction.userId) !== String(userId) ||
                transaction.type !== "credit" ||
                Math.abs(Number(transaction.amount) - numericAmount) > 0.001) {
                throw new Error("Transaction reference does not match this credit.");
            }
            if (transaction.status === "successful") {
                await session.abortTransaction();
                return {
                    message: "Duplicate credit ignored.",
                    duplicate: true,
                    amount: numericAmount,
                    newBalance: wallet.balance,
                    reference: txReference
                };
            }
            if (transaction.status !== "pending") {
                throw new Error("This transaction cannot be credited.");
            }
        } else {
            const created = await Transaction.create([{
                userId,
                walletId: wallet._id,
                type: "credit",
                amount: numericAmount,
                status: "pending",
                reference: txReference,
                description,
                provider
            }], { session });
            transaction = created[0];
        }

        wallet.balance = Number(wallet.balance || 0) + numericAmount;
        await wallet.save({ session });

        transaction.status = "successful";
        transaction.description = description || transaction.description;
        transaction.provider = provider || transaction.provider;
        await transaction.save({ session });

        await session.commitTransaction();
        return {
            message: "Wallet credited successfully.",
            amount: numericAmount,
            newBalance: wallet.balance,
            reference: txReference
        };
    } catch (error) {
        if (session.inTransaction()) await session.abortTransaction();
        console.error("LEDGER CREDIT ERROR:", error.message);
        throw error;
    } finally {
        await session.endSession();
    }
};

const debitWalletWithLedger = async ({
    userId,
    amount,
    description,
    provider = "africore",
    reference
}) => {
    const numericAmount = validAmount(amount);
    const txReference = reference || `txn_${uuidv4()}`;
    const session = await mongoose.startSession();

    try {
        session.startTransaction();
        const wallet = await Wallet.findOne({ userId }).session(session);
        if (!wallet) throw new Error("Wallet not found.");
        if (Number(wallet.balance || 0) < numericAmount) {
            throw new Error("Insufficient balance.");
        }

        const existing = await Transaction.findOne({ reference: txReference }).session(session);
        if (existing) {
            if (String(existing.userId) === String(userId) &&
                existing.type === "debit" &&
                existing.status === "successful") {
                await session.abortTransaction();
                return {
                    message: "Duplicate debit ignored.",
                    duplicate: true,
                    amount: numericAmount,
                    newBalance: wallet.balance,
                    reference: txReference
                };
            }
            throw new Error("Transaction reference already exists.");
        }

        const created = await Transaction.create([{
            userId,
            walletId: wallet._id,
            type: "debit",
            amount: numericAmount,
            status: "pending",
            reference: txReference,
            description,
            provider
        }], { session });

        wallet.balance = Number(wallet.balance || 0) - numericAmount;
        await wallet.save({ session });
        created[0].status = "successful";
        await created[0].save({ session });

        await session.commitTransaction();
        return {
            message: "Wallet debited successfully.",
            amount: numericAmount,
            newBalance: wallet.balance,
            reference: txReference
        };
    } catch (error) {
        if (session.inTransaction()) await session.abortTransaction();
        console.error("LEDGER DEBIT ERROR:", error.message);
        throw error;
    } finally {
        await session.endSession();
    }
};

module.exports = { creditWalletWithLedger, debitWalletWithLedger };
