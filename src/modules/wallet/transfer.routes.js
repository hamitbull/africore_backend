/**
 * ============================================
 * 💸 AFRICORE OS - TRANSFER ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const transferController = require("./transfer.controller");
const authMiddleware = require("../../middleware/auth.middleware");

// Protected route
router.post("/", authMiddleware, transferController.sendMoney);

module.exports = router;
