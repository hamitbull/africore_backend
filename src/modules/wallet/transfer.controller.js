/**
 * ============================================
 * 💸 AFRICORE OS - TRANSFER CONTROLLER
 * ============================================
 */

const { transferMoney } = require("./transfer.service");

const sendMoney = async (req, res) => {
    try {
        const senderId = req.user.id; // from auth middleware
        const { receiverAfroId, amount } = req.body;

        const result = await transferMoney({
            senderId,
            receiverAfroId,
            amount
        });

        return res.json(result);

    } catch (error) {
        console.error("❌ TRANSFER ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

module.exports = {
    sendMoney
};
