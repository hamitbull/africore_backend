/**
 * ============================================
 * 🆔 AFRICORE OS - AFRO ID GENERATOR
 * ============================================
 * Generates unique AFRO ID for every user
 */

const crypto = require("crypto");

// =============================
// GENERATE AFRO ID FUNCTION
// =============================
const generateAfroId = (name = "user") => {
    // Clean name (remove spaces & special chars)
    const cleanName = name
        .toLowerCase()
        .replace(/[^a-z0-9]/g, "");

    // Short random string
    const randomPart = crypto.randomBytes(2).toString("hex"); // e.g. a3f9

    // Timestamp for uniqueness
    const timePart = Date.now().toString().slice(-4);

    // Final AFRO ID
    return `${cleanName}${randomPart}${timePart}@afro`;
};

// =============================
// EXPORT
// =============================
module.exports = generateAfroId;

