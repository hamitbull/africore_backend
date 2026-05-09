/**
 * ============================================
 * 🪪 KYC MODEL
 * ============================================
 */

const mongoose = require("mongoose");

const kycSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    bvn: String,
    nin: String,

    idDocument: String,
    selfie: String,

    status: {
        type: String,
        enum: ["pending", "approved", "rejected"],
        default: "pending"
    }

}, { timestamps: true });

module.exports = mongoose.model("KYC", kycSchema);
