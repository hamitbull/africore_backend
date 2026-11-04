const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
        maxlength: 100
    },
    email: {
        type: String,
        trim: true,
        lowercase: true,
        sparse: true,
        unique: true
    },
    phone: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },
    dob: Date,
    afro_id: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    password: {
        type: String,
        required: true,
        select: false
    },
    role: {
        type: String,
        enum: ["user", "admin", "superadmin"],
        default: "user"
    },
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
    walletId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Wallet"
    }
}, {
    timestamps: true
});

userSchema.index({ phone: 1 });
userSchema.index({ afro_id: 1 });

module.exports = mongoose.models.User || mongoose.model("User", userSchema);
