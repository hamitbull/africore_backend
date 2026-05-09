/**
 * ============================================
 * 🪪 KYC SERVICE
 * ============================================
 */

const KYC = require("../../database/models/KYC");
const User = require("../../database/models/User");

// =============================
// SUBMIT KYC
// =============================
const submitKYC = async (userId, data) => {
    const kyc = await KYC.create({
        userId,
        ...data,
        status: "pending"
    });

    await User.findByIdAndUpdate(userId, {
        kycStatus: "pending"
    });

    return kyc;
};

// =============================
// APPROVE KYC (ADMIN)
// =============================
const approveKYC = async (kycId) => {
    const kyc = await KYC.findById(kycId);

    if (!kyc) throw new Error("KYC not found");

    kyc.status = "approved";
    await kyc.save();

    await User.findByIdAndUpdate(kyc.userId, {
        kycStatus: "verified",
        kycLevel: 2
    });

    return kyc;
};

// =============================
// REJECT KYC
// =============================
const rejectKYC = async (kycId) => {
    const kyc = await KYC.findById(kycId);

    if (!kyc) throw new Error("KYC not found");

    kyc.status = "rejected";
    await kyc.save();

    await User.findByIdAndUpdate(kyc.userId, {
        kycStatus: "rejected"
    });

    return kyc;
};

module.exports = {
    submitKYC,
    approveKYC,
    rejectKYC
};
