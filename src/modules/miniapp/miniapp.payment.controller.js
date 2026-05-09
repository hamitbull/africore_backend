/**
 * ============================================
 * 💳 MINI APP PAYMENT CONTROLLER
 * ============================================
 */

const {
    processMiniAppPayment
} = require("./miniapp.payment.service");

const payWithMiniApp = async (req, res) => {
    try {
        const userId = req.user.id;
        const { appId, amount, description } = req.body;

        const result = await processMiniAppPayment({
            userId,
            appId,
            amount,
            description
        });

        return res.json(result);

    } catch (error) {
        console.error(error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

module.exports = {
    payWithMiniApp
};
