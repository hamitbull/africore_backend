/**
 * ============================================
 * 📱 AFRICORE OS - MINI APP MODEL
 * ============================================
 */

const mongoose = require("mongoose");

const miniAppSchema = new mongoose.Schema({
    name: String,
    description: String,

    developerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    appUrl: String, // hosted frontend (web app)

    icon: String,

    isActive: {
        type: Boolean,
        default: false
    },

    category: String,

    permissions: {
        walletAccess: Boolean,
        userDataAccess: Boolean
    }

}, { timestamps: true });

module.exports = mongoose.model("MiniApp", miniAppSchema);
