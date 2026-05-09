/**
 * ============================================
 * 💳 AFRICORE OS - PAYMENT CONTROLLER
 * ============================================
 * Handles payment API requests & responses
 */

const {
    initiatePayment,
    verifyPayment
} = require("./payment.service");

// =============================
// INITIATE PAYMENT
// =============================
const startPayment = async (req, res) => {
    try {
        const { amount, email, tx_ref } = req.body;

        const result = await initiatePayment({ amount, email, tx_ref });

        return res.json({
            message: "Payment initiated",
            data: result
        });

    } catch (error) {
        console.error("❌ INITIATE PAYMENT ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// VERIFY PAYMENT
// =============================
const verifyUserPayment = async (req, res) => {
    try {
        const { transactionId, userId } = req.body;

        const result = await verifyPayment(transactionId, userId);

        return res.json(result);

    } catch (error) {
        console.error("❌ VERIFY PAYMENT ERROR:", error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// EXPORT CONTROLLER
// =============================
module.exports = {
    startPayment,
    verifyUserPayment
};
