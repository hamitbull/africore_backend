/**
 * ============================================
 * 💸 PAYOUT SERVICE
 * ============================================
 */

const Payout = require("../../database/models/Payout");
const Wallet = require("../../database/models/Wallet");

// =============================
// CREATE PAYOUT REQUEST
// =============================
const createPayout = async (developerId) => {
    const wallet = await Wallet.findOne({ userId: developerId });

    if (!wallet || wallet.balance <= 0) {
        throw new Error("No funds available");
    }

    const payout = await Payout.create({
        developerId,
        amount: wallet.balance,
        status: "pending"
    });

    return payout;
};

// =============================
// PROCESS PAYOUT (ADMIN)
// =============================

const { sendMoney } = require("../payments/flutterwave.transfer.service");

const processPayout = async (payoutId) => {
    const payout = await Payout.findById(payoutId);

    if (!payout) throw new Error("Payout not found");

    payout.status = "processing";
    await payout.save();

    const { accountNumber, bankCode } = payout.bankDetails;

    // 🔥 SEND MONEY VIA FLUTTERWAVE
    const transfer = await sendMoney({
        amount: payout.amount,
        accountNumber,
        bankCode,
        narration: "AFRICORE Developer Payout",
        reference: "AFRO_" + Date.now()
    });

    // ✅ SUCCESS
    payout.status = "paid";
    payout.reference = transfer.data.reference;

    await payout.save();

    return payout;
};

module.exports = {
    createPayout,
    processPayout
};
