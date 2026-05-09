/**
 * ============================================
 * 💳 MINI APP PAYMENT ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./miniapp.payment.controller");
const authMiddleware = require("../../middleware/auth.middleware");

// Pay endpoint
router.post("/pay", authMiddleware, controller.payWithMiniApp);

module.exports = router;
