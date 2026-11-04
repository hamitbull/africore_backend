const { initiatePayment, verifyPayment } = require("./payment.service");

const startPayment = async (req, res) => {
    try {
        const result = await initiatePayment({
            amount: req.body.amount,
            userId: req.user._id
        });
        return res.status(200).json(result);
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

const verifyUserPayment = async (req, res) => {
    try {
        const result = await verifyPayment(
            req.body.transactionId,
            req.user._id
        );
        return res.status(200).json(result);
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

module.exports = { startPayment, verifyUserPayment };
