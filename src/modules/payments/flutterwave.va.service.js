const axios = require("axios");
const env = require("../../config/env");

const createVirtualAccount = async (user) => {
    if (!user || !user.email) {
        throw new Error("A verified email address is required before requesting a virtual account.");
    }

    try {
        const response = await axios.post(
            "https://api.flutterwave.com/v3/virtual-account-numbers",
            {
                email: user.email,
                is_permanent: true,
                bvn: user.bvn || undefined,
                tx_ref: `AFRICORE_VA_${user._id}_${Date.now()}`,
                narration: `AFRICORE VA - ${user._id}`
            },
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`,
                    "Content-Type": "application/json"
                },
                timeout: 30000
            }
        );

        const data = response.data && response.data.data;
        if (!data || !data.account_number) {
            throw new Error("Flutterwave did not return virtual account details.");
        }

        return {
            accountNumber: data.account_number,
            bankName: data.bank_name || "",
            accountName: data.account_name || ""
        };
    } catch (error) {
        console.error("Flutterwave virtual account error:", error.response?.data || error.message);
        throw new Error("Failed to create virtual account.");
    }
};

module.exports = { createVirtualAccount };
