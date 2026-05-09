/**
 * ============================================
 * 💳 MINI APP PAYMENT SERVICE
 * ============================================
 */

const { checkFraud } = require("../security/fraud.service");
const MiniApp = require("../../database/models/MiniApp");
const calculateFee = require("../../utils/feeCalculator");

const {
    debitWalletWithLedger,
    creditWalletWithLedger
} = require("../wallet/ledger.service");

const PLATFORM_OWNER_ID = process.env.PLATFORM_OWNER_ID;

// =============================
// PROCESS PAYMENT
// =============================
const processMiniAppPayment = async ({
    userId,
    appId,
    amount,
    description
}) => {
    if (!amount || amount <= 0) {
        throw new Error("Invalid amount");
    }

    const app = await MiniApp.findById(appId);

    if (!app || !app.isActive) {
        throw new Error("App not available");
    }

    if (!app.permissions?.walletAccess) {
        throw new Error("App not allowed to use wallet");
    }

    // 💰 CALCULATE FEE
    const { fee, developerAmount } = calculateFee(amount);

await checkFraud({
    userId,
    amount
});

    // 💸 DEBIT USER
    const debit = await debitWalletWithLedger({
        userId,
        amount,
        description: `${app.name} payment`,
        provider: "miniapp"
    });

    await sendNotification({
    userId,
    title: "Payment Successful",
    message: `You paid ₦${amount} for ${app.name}`,
    type: "payment"
}); 

    // 💰 CREDIT DEVELOPER
    if (app.developerId) {
        await creditWalletWithLedger({
            userId: app.developerId,
            amount: developerAmount,
            description: `Earnings from ${app.name}`,
            provider: "miniapp"
        });
    }

    // 💼 PLATFORM FEE
    await creditWalletWithLedger({
        userId: PLATFORM_OWNER_ID,
        amount: fee,
        description: `Platform fee from ${app.name}`,
        provider: "platform-fee"
    });

    return {
        message: "Payment successful",
        totalPaid: amount,
        fee,
        developerReceived: developerAmount,
        newBalance: debit.newBalance
    };
};

module.exports = {
    processMiniAppPayment
};
