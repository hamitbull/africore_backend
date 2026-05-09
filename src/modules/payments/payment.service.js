/**
 * ============================================
 * 💳 AFRICORE OS - PAYMENT SERVICE
 * ============================================
 */

const axios = require("axios");
const env = require("../../config/env");
const Wallet = require("../../database/models/Wallet");

// =============================
// INITIATE PAYMENT
// =============================
const initiatePayment = async ({ amount, email, tx_ref, userId }) => {
    if (!amount || !email || !userId) {
        throw new Error("Amount, email and userId are required");
    }

    const payload = {
        tx_ref: tx_ref,
        amount: amount,
        currency: "NGN",
        redirect_url: env.APP_URL,
        customer: {
            email: email
        },
        payment_options: "card,banktransfer,ussd",
        meta: {
            userId: userId
        }
    };

    try {
        const response = await axios.post(
            "https://api.flutterwave.com/v3/payments",
            payload,
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`
                }
            }
        );

        return response.data;

    } catch (error) {
        console.error("❌ PAYMENT INIT ERROR:", error.message);
        throw new Error("Payment initialization failed");
    }
};

// =============================
// VERIFY PAYMENT
// =============================
const verifyPayment = async (transactionId, userId) => {
    try {
        const response = await axios.get(
            `https://api.flutterwave.com/v3/transactions/${transactionId}/verify`,
            {
                headers: {
                    Authorization: `Bearer ${env.FLW_SECRET_KEY}`
                }
            }
        );

        const data = response.data.data;

        if (data.status === "successful") {
            const wallet = await Wallet.findOne({ userId });

            if (!wallet) {
                throw new Error("Wallet not found");
            }

            wallet.balance += data.amount;
            await wallet.save();

            return {
                message: "Payment verified & wallet credited",
                amount: data.amount,
                newBalance: wallet.balance
            };
        }

        return {
            message: "Payment not successful",
            status: data.status
        };

    } catch (error) {
        console.error("❌ VERIFY ERROR:", error.message);
        throw new Error("Payment verification failed");
    }
};

// =============================
// EXPORT
// =============================
module.exports = {
    initiatePayment,
    verifyPayment
};
