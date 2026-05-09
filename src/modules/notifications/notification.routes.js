/**
 * ============================================
 * 📩 NOTIFICATION ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./notification.controller");
const authMiddleware = require("../../middleware/auth.middleware");

// Get notifications
router.get("/", authMiddleware, controller.fetchNotifications);

// Mark as read
router.put("/:id/read", authMiddleware, controller.readNotification);

module.exports = router;
