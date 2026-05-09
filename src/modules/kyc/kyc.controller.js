/**
 * ============================================
 * 🪪 KYC CONTROLLER
 * ============================================
 */

const {
    submitKYC,
    approveKYC,
    rejectKYC
} = require("./kyc.service");

// User submit
const submit = async (req, res) => {
    try {
        const kyc = await submitKYC(req.user.id, req.body);

        res.json({
            message: "KYC submitted",
            kyc
        });

    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

// Admin approve
const approve = async (req, res) => {
    const kyc = await approveKYC(req.params.id);
    res.json(kyc);
};

// Admin reject
const reject = async (req, res) => {
    const kyc = await rejectKYC(req.params.id);
    res.json(kyc);
};

module.exports = {
    submit,
    approve,
    reject
};
