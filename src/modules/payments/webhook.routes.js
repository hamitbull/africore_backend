/**
 * ============================================
 * 🔐 WEBHOOK ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./payout.webhook.controller");

// ⚠️ NO authMiddleware here
router.post("/flutterwave", controller.handleFlutterwaveWebhook);

module.exports = router;
