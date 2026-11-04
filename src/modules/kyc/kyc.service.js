const KYC = require("../../database/models/KYC");
const User = require("../../database/models/User");

// Raw BVN/NIN and identity documents must not be accepted until encrypted
// document storage and an approved identity-verification provider are configured.
const submitKYC = async () => {
    throw new Error(
        "KYC submission is temporarily unavailable. Secure identity verification has not been configured."
    );
};

const approveKYC = async (kycId) => {
    const kyc = await KYC.findById(kycId);
    if (!kyc) throw new Error("KYC record not found.");

    kyc.status = "approved";
    await kyc.save();
    await User.findByIdAndUpdate(kyc.userId, {
        kycStatus: "verified",
        kycLevel: 2
    });
    return kyc;
};

const rejectKYC = async (kycId) => {
    const kyc = await KYC.findById(kycId);
    if (!kyc) throw new Error("KYC record not found.");

    kyc.status = "rejected";
    await kyc.save();
    await User.findByIdAndUpdate(kyc.userId, {
        kycStatus: "rejected"
    });
    return kyc;
};

module.exports = { submitKYC, approveKYC, rejectKYC };
