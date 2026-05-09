/**
 * ============================================
 * 💰 AFRICORE OS - WALLET ROUTES
 * ============================================
 * Defines wallet API endpoints
 */

const express = require("express");
const router = express.Router();

// Import controller
const walletController = require("./wallet.controller");

// =============================
// CREATE WALLET
// =============================
router.post("/create", walletController.createUserWallet);

// =============================
// GET WALLET BALANCE
// =============================
router.get("/:userId", walletController.getWalletBalance);

// =============================
// CREDIT WALLET
// =============================
router.post("/credit", walletController.creditUserWallet);

// =============================
// DEBIT WALLET
// =============================
router.post("/debit", walletController.debitUserWallet);

// =============================
// EXPORT ROUTER
// =============================
module.exports = router;
