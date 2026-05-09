/**
 * ============================================
 * 📩 NOTIFICATION SERVICE
 * ============================================
 */

const Notification = require("../../database/models/Notification");

// =============================
// CREATE NOTIFICATION
// =============================
const sendNotification = async ({
    userId,
    title,
    message,
    type = "system"
}) => {
    return await Notification.create({
        userId,
        title,
        message,
        type
    });
};

// =============================
// GET USER NOTIFICATIONS
// =============================
const getUserNotifications = async (userId) => {
    return await Notification.find({ userId })
        .sort({ createdAt: -1 });
};

// =============================
// MARK AS READ
// =============================
const markAsRead = async (notificationId) => {
    return await Notification.findByIdAndUpdate(
        notificationId,
        { isRead: true },
        { new: true }
    );
};

module.exports = {
    sendNotification,
    getUserNotifications,
    markAsRead
};
