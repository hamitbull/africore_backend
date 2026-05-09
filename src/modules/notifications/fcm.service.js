/**
 * ============================================
 * 🔔 FCM PUSH NOTIFICATION SERVICE
 * ============================================
 */

const admin = require("firebase-admin");

// =============================
// SEND PUSH NOTIFICATION
// =============================
const sendPushNotification = async ({
    token,
    title,
    body
}) => {
    try {

        const message = {
            notification: {
                title,
                body
            },
            token
        };

        const response = await admin.messaging().send(message);

        return response;

    } catch (error) {
        console.error("❌ FCM ERROR:", error.message);
    }
};

module.exports = {
    sendPushNotification
};
