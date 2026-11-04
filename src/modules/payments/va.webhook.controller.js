const crypto = require("crypto");
const env = require("../../config/env");
const User = require("../../database/models/User");
const { creditWalletWithLedger } = require("../wallet/ledger.service");

const handleVAWebhook = async (req, res) => {
    try {
        const secret = env.FLW_WEBHOOK_SECRET;
        const signature = req.headers["verif-hash"];
        if (!secret || !signature || signature.length !== secret.length ||
            !crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(secret))) {
            return res.sendStatus(401);
        }

        const payload = req.body || {};
        const data = payload.data || {};
        if (payload.event !== "charge.completed" || data.status !== "successful") {
            return res.sendStatus(200);
        }
        if (data.payment_type !== "bank_transfer") return res.sendStatus(200);

        const accountNumber = String(data.account_number || "");
        const amount = Number(data.amount);
        const providerId = data.id || data.flw_ref || data.tx_ref;
        if (!accountNumber || !providerId || !Number.isFinite(amount) || amount <= 0) {
            return res.status(400).send("Invalid virtual account payment payload");
        }

        const user = await User.findOne({
            "virtualAccount.accountNumber": accountNumber
        }).select("_id");
        if (!user) return res.sendStatus(200);

        const result = await creditWalletWithLedger({
            userId: user._id,
            amount,
            description: "Wallet funding by virtual account",
            provider: "flutterwave-virtual-account",
            reference: `FLWVA_${providerId}`
        });
        return res.status(200).json({ message: result.message });
    } catch (error) {
        console.error("Virtual account webhook failed:", error.message);
        return res.sendStatus(500);
    }
};

module.exports = { handleVAWebhook };
