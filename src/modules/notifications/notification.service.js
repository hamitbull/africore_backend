const Notification = require("../../database/models/Notification");

const sendNotification = async ({ userId, title, message, type = "system" }) => {
    return Notification.create({ userId, title, message, type });
};

const getUserNotifications = async (userId) => {
    return Notification.find({ userId }).sort({ createdAt: -1 }).limit(100);
};

// A user may only mark their own notification as read.
const markAsRead = async (notificationId, userId) => {
    return Notification.findOneAndUpdate(
        { _id: notificationId, userId },
        { isRead: true },
        { new: true }
    );
};

module.exports = { sendNotification, getUserNotifications, markAsRead };
