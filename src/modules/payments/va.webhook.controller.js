/**
 * ============================================
 * 💰 VA FUNDING WEBHOOK
 * ============================================
 */

const User = require("../../database/models/User");

const {
    creditWalletWithLedger
} = require("../wallet/ledger.service");

const handleVAWebhook = async (req, res) => {
    try {
    const signature = req.headers["verif-hash"];

if (signature !== process.env.FLW_WEBHOOK_SECRET) {
    return res.sendStatus(401);
}
        
const payload = req.body;

        if (payload.event === "charge.completed") {

            const data = payload.data;

            // Only bank transfer
            if (data.payment_type !== "bank_transfer") {
                return res.sendStatus(200);
            }

            const accountNumber = data.account_number;
            const amount = data.amount;

            // Find user
            const user = await User.findOne({
                "virtualAccount.accountNumber": accountNumber
            });

            if (!user) return res.sendStatus(200);

            // Credit wallet
            await creditWalletWithLedger({
                userId: user._id,
                amount,
                description: "Wallet funding (VA)",
                provider: "virtual-account"
            });
        }

        return res.sendStatus(200);

    } catch (error) {
        console.error("❌ VA WEBHOOK ERROR:", error.message);
        return res.sendStatus(500);
    }
};

module.exports = {
    handleVAWebhook
};
