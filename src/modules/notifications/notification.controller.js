/**
 * ============================================
 * 📩 NOTIFICATION CONTROLLER
 * ============================================
 */

const {
    getUserNotifications,
    markAsRead
} = require("./notification.service");

// =============================
// GET NOTIFICATIONS
// =============================
const fetchNotifications = async (req, res) => {
    try {
        const userId = req.user.id;

        const notifications = await getUserNotifications(userId);

        return res.json(notifications);

    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch notifications"
        });
    }
};

// =============================
// MARK READ
// =============================
const readNotification = async (req, res) => {
    try {
        const { id } = req.params;

        const updated = await markAsRead(id);

        return res.json(updated);

    } catch (error) {
        return res.status(400).json({
            message: "Failed to update"
        });
    }
};

module.exports = {
    fetchNotifications,
    readNotification
};
