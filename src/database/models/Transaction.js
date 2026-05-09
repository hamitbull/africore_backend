/**
 * ============================================
 * 📊 AFRICORE OS - TRANSACTION MODEL
 * ============================================
 * Records all financial activities
 */

const mongoose = require("mongoose");

// =============================
// TRANSACTION SCHEMA
// =============================
const transactionSchema = new mongoose.Schema(
    {
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true
        },

        walletId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Wallet",
            required: true
        },

        type: {
            type: String,
            enum: ["credit", "debit"],
            required: true
        },

        amount: {
            type: Number,
            required: true
        },

        currency: {
            type: String,
            default: "NGN"
        },

        status: {
            type: String,
            enum: ["pending", "successful", "failed"],
            default: "pending"
        },

        reference: {
            type: String,
            unique: true
        },

        description: {
            type: String
        },

        // For external payments (Flutterwave)
        provider: {
            type: String,
            default: "africore"
        },

        metadata: {
            type: Object
        }
    },
    {
        timestamps: true
    }
);

// =============================
// INDEXES (FAST QUERIES)
// =============================
transactionSchema.index({ userId: 1 });
transactionSchema.index({ walletId: 1 });
transactionSchema.index({ reference: 1 });

// =============================
// EXPORT MODEL
// =============================
const Transaction = mongoose.model("Transaction", transactionSchema);

module.exports = Transaction;
