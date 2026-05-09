/**
 * ============================================
 * 🏦 FLUTTERWAVE VIRTUAL ACCOUNT SERVICE
 * ============================================
 */

const axios = require("axios");
const env = require("../../config/env");

const createVirtualAccount = async (user) => {
    try {
        const response = await axios.post(
            `${env.FLW_BASE_URL}/virtual-account-numbers`,
            {
                email: user.email,
                is_permanent: true,
                bvn: user.bvn || undefined,
                tx_ref: "VA_" + Date.now(),
                narration: `AFRICORE VA - ${user._id}`
            },
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`
                }
            }
        );

        const data = response.data.data;

        return {
            accountNumber: data.account_number,
            bankName: data.bank_name,
            accountName: data.account_name
        };

    } catch (error) {
        console.error("❌ VA ERROR:", error.response?.data || error.message);
        throw new Error("Failed to create virtual account");
    }
};

module.exports = {
    createVirtualAccount
};
