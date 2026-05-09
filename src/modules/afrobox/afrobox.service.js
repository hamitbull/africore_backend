/**
 * ============================================
 * 📦 AFROBOX SERVICE
 * ============================================
 */

const crypto = require("crypto");

// =============================
// GENERATE AFROBOX TOKEN
// =============================
const generateAfroboxToken = () => {
    return crypto.randomBytes(32).toString("hex");
};

// =============================
// CREATE SECURE SESSION
// =============================
const createSecureSession = (userId) => {
    return {
        sessionId: crypto.randomUUID(),
        userId,
        createdAt: new Date()
    };
};

// =============================
// VALIDATE SESSION
// =============================
const validateSession = (session) => {
    if (!session) return false;

    const now = new Date();
    const created = new Date(session.createdAt);

    const diff = (now - created) / 1000 / 60;

    // expire after 60 mins
    return diff < 60;
};

module.exports = {
    generateAfroboxToken,
    createSecureSession,
    validateSession
};
