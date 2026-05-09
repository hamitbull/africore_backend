/**
 * ============================================
 * 👤 AFRICORE OS - USER MODEL
 * ============================================
 * Defines user schema & structure
 */

const mongoose = require("mongoose");

// =============================
// USER SCHEMA
// =============================
const userSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            trim: true
        },

        phone: {
            type: String,
            required: true,
            unique: true
        },

        dob: {
            type: Date
        },

        afro_id: {
            type: String,
            required: true,
            unique: true
        },

        password: {
            type: String,
            required: true
        },

    role: {
    type: String,
    enum: ["user", "admin", "superadmin"],
    default: "user"
  },


        // 🔐 Account Status
        isVerified: {
            type: Boolean,
            default: false
        },

virtualAccount: {
    accountNumber: String,
    bankName: String,
    accountName: String
},

   kycLevel: {
    type: Number,
    default: 0
},

kycStatus: {
    type: String,
    enum: ["unverified", "pending", "verified", "rejected"],
    default: "unverified"
},
//   bvn: String,
//nin: String,

//idDocument: String,
//selfie: String 


        // 💰 Wallet Link (future)
        walletId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Wallet"
        }

    },
    {
        timestamps: true // createdAt & updatedAt
    }
);

// =============================
// INDEXES (Performance)
// =============================
userSchema.index({ phone: 1 });
userSchema.index({ afro_id: 1 });

// =============================
// EXPORT MODEL
// =============================
const User = mongoose.model("User", userSchema);

module.exports = User;
