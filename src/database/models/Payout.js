/**
 * ============================================
 * 💸 PAYOUT MODEL
 * ============================================
 */

const mongoose = require("mongoose");

const payoutSchema = new mongoose.Schema({
    developerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    amount: Number,

    status: {
        type: String,
        enum: ["pending", "processing", "paid", "failed"],
        default: "pending"
    },

    reference: String,

    bankDetails: {
        accountNumber: String,
        bankCode: String,
        accountName: String
    }

}, { timestamps: true });

module.exports = mongoose.model("Payout", payoutSchema);
