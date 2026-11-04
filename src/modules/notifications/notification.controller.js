const {
    getUserNotifications,
    markAsRead
} = require("./notification.service");

const fetchNotifications = async (req, res) => {
    try {
        const notifications = await getUserNotifications(req.user._id);
        return res.status(200).json({ notifications });
    } catch (error) {
        return res.status(500).json({ message: "Failed to fetch notifications" });
    }
};

const readNotification = async (req, res) => {
    try {
        const updated = await markAsRead(req.params.id, req.user._id);
        if (!updated) return res.status(404).json({ message: "Notification not found" });
        return res.status(200).json(updated);
    } catch (error) {
        return res.status(400).json({ message: "Failed to update notification" });
    }
};

module.exports = { fetchNotifications, readNotification };
