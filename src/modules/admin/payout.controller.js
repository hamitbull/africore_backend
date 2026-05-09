/**
 * ============================================
 * 💸 PAYOUT CONTROLLER
 * ============================================
 */

const {
    createPayout,
    processPayout
} = require("./payout.service");

// Developer requests payout
const requestPayout = async (req, res) => {
    try {
        const payout = await createPayout(req.user.id);

        return res.json({
            message: "Payout requested",
            payout
        });

    } catch (error) {
        return res.status(400).json({
            message: error.message
        });
    }
};

// Admin processes payout
const handlePayout = async (req, res) => {
    try {
        const payout = await processPayout(req.params.id);

        return res.json({
            message: "Payout processed",
            payout
        });

    } catch (error) {
        return res.status(400).json({
            message: error.message
        });
    }
};

module.exports = {
    requestPayout,
    handlePayout
};
