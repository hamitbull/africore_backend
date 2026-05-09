/**
 * ============================================
 * 💰 AFRICORE OS - WALLET MODEL
 * ============================================
 */

const mongoose = require("mongoose");

// =============================
// WALLET SCHEMA
// =============================
const walletSchema = new mongoose.Schema(
    {
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
            unique: true
        },

        balance: {
            type: Number,
            default: 0
        },

        currency: {
            type: String,
            default: "NGN"
        },

        isActive: {
            type: Boolean,
            default: true
        },

        // 🏦 Virtual Account
        accountNumber: {
            type: String
        },

        bankName: {
            type: String
        },

        accountReference: {
            type: String
        }
    },
    {
        timestamps: true
    }
);

// =============================
// INDEX FOR PERFORMANCE
// =============================
walletSchema.index({ userId: 1 });

// =============================
// EXPORT MODEL
// =============================
const Wallet = mongoose.model("Wallet", walletSchema);

module.exports = Wallet;
