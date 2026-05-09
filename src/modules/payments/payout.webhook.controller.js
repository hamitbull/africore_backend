/**
 * ============================================
 * 🔐 PAYOUT WEBHOOK CONTROLLER
 * ============================================
 */

const Payout = require("../../database/models/Payout");

const handleFlutterwaveWebhook = async (req, res) => {
    try {
        const secretHash = process.env.FLW_WEBHOOK_SECRET;
        const signature = req.headers["verif-hash"];

        // 🔐 VERIFY SIGNATURE
        if (!signature || signature !== secretHash) {
            return res.status(401).json({
                message: "Invalid webhook signature"
            });
        }

        const payload = req.body;

        // =============================
        // CHECK EVENT TYPE
        // =============================
        if (payload.event === "transfer.completed") {

            const data = payload.data;

            const reference = data.reference;

            // =============================
            // FIND PAYOUT
            // =============================
            const payout = await Payout.findOne({ reference });

            if (!payout) {
                return res.status(404).json({
                    message: "Payout not found"
                });
            }

            // 🔐 SECURITY CHECK (VERY IMPORTANT)
if (payload.data.amount !== payout.amount) {
    console.error("❌ Amount mismatch!");

    return res.status(400).json({
        message: "Amount mismatch"
    });
}


            // =============================
            // UPDATE STATUS
            // =============================
            if (data.status === "SUCCESSFUL") {
                payout.status = "paid";
            } else {
                payout.status = "failed";
            }

            await payout.save();
        }

        return res.status(200).json({
            message: "Webhook received"
        });

    } catch (error) {
        console.error("❌ WEBHOOK ERROR:", error.message);

        return res.status(500).json({
            message: "Webhook error"
        });
    }
};

module.exports = {
    handleFlutterwaveWebhook
};
