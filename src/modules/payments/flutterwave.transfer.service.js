/**
 * ============================================
 * 💳 FLUTTERWAVE TRANSFER SERVICE
 * ============================================
 */

const axios = require("axios");
const env = require("../../config/env");

const sendMoney = async ({
    amount,
    accountNumber,
    bankCode,
    narration,
    reference
}) => {
    try {
        const response = await axios.post(
            `${env.FLW_BASE_URL}/transfers`,
            {
                account_bank: bankCode,
                account_number: accountNumber,
                amount,
                narration,
                currency: "NGN",
                reference
            },
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`
                }
            }
        );

        return response.data;

    } catch (error) {
        console.error("❌ FLW TRANSFER ERROR:", error.response?.data || error.message);
        throw new Error("Transfer failed");
    }
};

module.exports = {
    sendMoney
};
