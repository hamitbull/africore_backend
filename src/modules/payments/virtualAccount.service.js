/**
 * ============================================
 * 🏦 AFRICORE OS - VIRTUAL ACCOUNT SERVICE
 * ============================================
 */

const axios = require("axios");
const env = require("../../config/env");
const Wallet = require("../../database/models/Wallet");

const createVirtualAccount = async ({ userId, email, name }) => {
    try {
        const payload = {
            email: email,
            is_permanent: true,
            bvn: "12345678901", // (for now test)
            tx_ref: `acct_${Date.now()}`,
            firstname: name.split(" ")[0],
            lastname: name.split(" ")[1] || "User",
            narration: "AFRICORE Virtual Account"
        };

        const response = await axios.post(
            "https://api.flutterwave.com/v3/virtual-account-numbers",
            payload,
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`
                }
            }
        );

        const data = response.data.data;

        // Save to wallet
        const wallet = await Wallet.findOne({ userId });

        wallet.accountNumber = data.account_number;
        wallet.bankName = data.bank_name;
        wallet.accountReference = data.order_ref;

        await wallet.save();

        return {
            accountNumber: wallet.accountNumber,
            bankName: wallet.bankName
        };

    } catch (error) {
        console.error("❌ VIRTUAL ACCOUNT ERROR:", error.response?.data || error.message);
        throw new Error("Failed to create virtual account");
    }
};

module.exports = {
    createVirtualAccount
};
