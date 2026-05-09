/**
 * ============================================
 * 🔑 SESSION SERVICE
 * ============================================
 */

const sessions = new Map();

// =============================
// SAVE SESSION
// =============================
const saveSession = (sessionId, data) => {
    sessions.set(sessionId, data);
};

// =============================
// GET SESSION
// =============================
const getSession = (sessionId) => {
    return sessions.get(sessionId);
};

// =============================
// DELETE SESSION
// =============================
const deleteSession = (sessionId) => {
    sessions.delete(sessionId);
};

module.exports = {
    saveSession,
    getSession,
    deleteSession
};
