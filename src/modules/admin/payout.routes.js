/**
 * ============================================
 * 💸 PAYOUT ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const controller = require("./payout.controller");
const authMiddleware = require("../../middleware/auth.middleware");
const adminMiddleware = require("../../middleware/admin.middleware");

// Developer request
router.post("/request", authMiddleware, controller.requestPayout);

// Admin process
router.put("/process/:id", authMiddleware, adminMiddleware, controller.handlePayout);

module.exports = router;
