/**
 * ============================================
 * 📊 ANALYTICS ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./analytics.controller");
const authMiddleware = require("../../middleware/auth.middleware");

// 🔐 Protect route (admin only later)
router.get("/dashboard", authMiddleware, controller.getDashboard);

module.exports = router;
