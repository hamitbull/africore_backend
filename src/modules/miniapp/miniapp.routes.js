/**
 * ============================================
 * 📱 MINI APP ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./miniapp.controller");
const authMiddleware = require("../../middleware/auth.middleware");

// Developer submit app
router.post("/submit", authMiddleware, controller.submitApp);

// Get all apps
router.get("/", controller.fetchApps);

module.exports = router;
