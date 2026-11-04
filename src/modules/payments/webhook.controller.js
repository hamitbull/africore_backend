const crypto = require("crypto");
const env = require("../../config/env");
const { creditWalletWithLedger } = require("../wallet/ledger.service");

const handleWebhook = async (req, res) => {
    try {
        const secret = env.FLW_WEBHOOK_SECRET;
        const signature = req.headers["verif-hash"];
        if (!secret || !signature || signature.length !== secret.length ||
            !crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(secret))) {
            return res.status(401).end();
        }

        const payload = req.body || {};
        const data = payload.data || {};
        if (payload.event !== "charge.completed" || data.status !== "successful") {
            return res.status(200).json({ message: "Event ignored" });
        }

        const userId = data.meta?.userId;
        const reference = String(data.tx_ref || "");
        const amount = Number(data.amount);
        if (!userId || !reference || !Number.isFinite(amount) || amount <= 0) {
            return res.status(400).json({ message: "Invalid payment payload" });
        }

        const result = await creditWalletWithLedger({
            userId,
            amount,
            description: "Flutterwave wallet funding",
            provider: "flutterwave",
            reference
        });
        return res.status(200).json({ message: result.message, data: result });
    } catch (error) {
        console.error("Flutterwave webhook processing failed:", error.message);
        return res.status(500).end();
    }
};

module.exports = { handleWebhook };
