/**
 * ============================================
 * 🔥 AFRICORE OS - WEBHOOK CONTROLLER (LEDGER VERSION)
 * ============================================
 * Secure auto-payment processing using Ledger system
 */

const env = require("../../config/env");
const Transaction = require("../../database/models/Transaction");

// 🔥 IMPORT LEDGER
const {
    creditWalletWithLedger
} = require("../wallet/ledger.service");

// =============================
// HANDLE FLUTTERWAVE WEBHOOK
// =============================
const handleWebhook = async (req, res) => {
    try {
        const secretHash = env.FLW_SECRET_KEY;
        const signature = req.headers["verif-hash"];

        // =============================
        // VERIFY SIGNATURE
        // =============================
        if (!signature || signature !== secretHash) {
            console.error("❌ Invalid webhook signature");
            return res.status(401).end();
        }

        const payload = req.body;

        // =============================
        // HANDLE SUCCESSFUL PAYMENT
        // =============================
        if (payload.event === "charge.completed") {
            const data = payload.data;

            if (data.status === "successful") {
                const userId = data.meta?.userId;
                const amount = data.amount;
                const reference = data.tx_ref || data.id;

                if (!userId) {
                    console.error("❌ Missing userId in metadata");
                    return res.status(400).end();
                }

                // =============================
                // 🔒 PREVENT DUPLICATE CREDIT
                // =============================
                const existingTx = await Transaction.findOne({ reference });

                if (existingTx) {
                    console.log("⚠️ Duplicate transaction ignored:", reference);
                    return res.status(200).json({
                        message: "Duplicate transaction ignored"
                    });
                }

                // =============================
                // 💰 USE LEDGER (SAFE CREDIT)
                // =============================
                const result = await creditWalletWithLedger({
                    userId,
                    amount,
                    description: "Flutterwave deposit",
                    provider: "flutterwave"
                });

                console.log("💰 Ledger credit success:", result);

                return res.status(200).json({
                    message: "Webhook processed with ledger",
                    data: result
                });
            }
        }

        return res.status(200).json({
            message: "Event ignored"
        });

    } catch (error) {
        console.error("❌ WEBHOOK ERROR:", error.message);

        return res.status(500).end();
    }
};

// =============================
// EXPORT
// =============================
module.exports = {
    handleWebhook
};
