/**
 * ============================================
 * 💰 AFRICORE OS - FEE CALCULATOR
 * ============================================
 * Calculates platform fee and developer share
 */

const { PLATFORM_FEE_PERCENT, MIN_FEE } = require("../config/fee.config");

/**
 * Function to calculate fee and developer share
 * @param {number} amount - The amount to calculate fee on
 * @returns {object} fee and developer amount
 */
const calculateFee = (amount) => {
    // Calculate fee based on percentage
    let fee = (amount * PLATFORM_FEE_PERCENT) / 100;

    // Ensure fee is not below minimum
    if (fee < MIN_FEE) {
        fee = MIN_FEE;
    }

    // Developer receives the amount after fee
    const developerAmount = amount - fee;

    return {
        total: amount,
        fee,
        developerAmount
    };
};

module.exports = calculateFee;
