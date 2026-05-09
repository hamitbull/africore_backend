/**
 * ============================================
 * 💳 AFRICORE OS - PAYMENT ROUTES
 * ============================================
 * Defines payment API endpoints
 */

const express = require("express");
const router = express.Router();

// Import controller
const paymentController = require("./payment.controller");
const webhookController = require("./webhook.controller");

// =============================
// INITIATE PAYMENT
// =============================
router.post("/initiate", paymentController.startPayment);

// =============================
// VERIFY PAYMENT
// =============================
router.post("/verify", paymentController.verifyUserPayment);
router.post("/webhook", webhookController.handleWebhook);


// =============================
// EXPORT ROUTER
// =============================
module.exports = router;
