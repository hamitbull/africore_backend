/**
 * ============================================
 * 🔐 OTP SERVICE
 * ============================================
 */

const otpStore = new Map();

// =============================
// GENERATE OTP
// =============================
const generateOTP = (phone) => {
    const otp = Math.floor(100000 + Math.random() * 900000);

    otpStore.set(phone, {
        otp,
        createdAt: Date.now()
    });

    return otp;
};

// =============================
// VERIFY OTP
// =============================
const verifyOTP = (phone, otp) => {
    const data = otpStore.get(phone);

    if (!data) return false;

    // expire after 5 mins
    const isExpired =
        (Date.now() - data.createdAt) > 5 * 60 * 1000;

    if (isExpired) {
        otpStore.delete(phone);
        return false;
    }

    return data.otp == otp;
};

module.exports = {
    generateOTP,
    verifyOTP
};
