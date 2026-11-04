const axios = require("axios");
const { v4: uuidv4 } = require("uuid");
const env = require("../../config/env");
const User = require("../../database/models/User");
const Wallet = require("../../database/models/Wallet");
const Transaction = require("../../database/models/Transaction");
const { creditWalletWithLedger } = require("../wallet/ledger.service");

const FLW_URL = "https://api.flutterwave.com/v3";
const flwHeaders = {
    Authorization: `Bearer ${env.FLW_SECRET_KEY}`,
    "Content-Type": "application/json"
};

const initiatePayment = async ({ amount, userId }) => {
    const numericAmount = Number(amount);
    if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
        throw new Error("Enter a valid positive amount.");
    }

    const [user, wallet] = await Promise.all([
        User.findById(userId).select("email"),
        Wallet.findOne({ userId })
    ]);
    if (!user || !user.email) throw new Error("Add a valid email address to your account before funding.");
    if (!wallet) throw new Error("Wallet not found.");

    const txRef = `AFRO_${uuidv4()}`;
    await Transaction.create({
        userId,
        walletId: wallet._id,
        type: "credit",
        amount: numericAmount,
        status: "pending",
        reference: txRef,
        description: "Wallet funding",
        provider: "flutterwave"
    });

    try {
        const response = await axios.post(
            `${FLW_URL}/payments`,
            {
                tx_ref: txRef,
                amount: numericAmount,
                currency: "NGN",
                ...(env.APP_URL ? { redirect_url: env.APP_URL } : {}),
                customer: { email: user.email },
                payment_options: "card,banktransfer,ussd",
                meta: { userId: userId.toString() }
            },
            { headers: flwHeaders, timeout: 30000 }
        );
        return {
            message: "Payment initiated",
            tx_ref: txRef,
            checkout: response.data
        };
    } catch (error) {
        await Transaction.updateOne(
            { reference: txRef, userId },
            { $set: { status: "failed" } }
        );
        console.error("Flutterwave payment initiation failed:", error.response?.data || error.message);
        throw new Error("Payment initialization failed.");
    }
};

const verifyPayment = async (transactionId, userId) => {
    if (!transactionId) throw new Error("Flutterwave transaction ID is required.");

    const response = await axios.get(
        `${FLW_URL}/transactions/${encodeURIComponent(transactionId)}/verify`,
        { headers: flwHeaders, timeout: 30000 }
    );
    const data = response.data?.data;
    if (!data || data.status !== "successful") {
        return { message: "Payment is not successful.", status: data?.status || "unknown" };
    }
    if (String(data.currency).toUpperCase() !== "NGN") {
        throw new Error("Payment currency does not match NGN.");
    }

    const reference = String(data.tx_ref || "");
    const pending = await Transaction.findOne({
        reference,
        userId,
        provider: "flutterwave",
        type: "credit"
    });
    if (!pending) throw new Error("Payment reference was not found for this account.");
    if (pending.status === "successful") {
        return { message: "Payment already credited.", duplicate: true, reference };
    }
    if (pending.status !== "pending") throw new Error("This payment is no longer pending.");

    const paidAmount = Number(data.amount);
    if (!Number.isFinite(paidAmount) || Math.abs(paidAmount - Number(pending.amount)) > 0.001) {
        throw new Error("Verified payment amount does not match the requested amount.");
    }

    return creditWalletWithLedger({
        userId,
        amount: pending.amount,
        description: "Flutterwave wallet funding",
        provider: "flutterwave",
        reference
    });
};

module.exports = { initiatePayment, verifyPayment };
