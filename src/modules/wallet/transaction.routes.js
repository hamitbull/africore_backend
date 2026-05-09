/**
 * ============================================
 * 📊 AFRICORE OS - TRANSACTION ROUTES
 * ============================================
 */

const express = require("express");
const router = express.Router();

const transactionController = require("./transaction.controller");

// =============================
// GET USER TRANSACTIONS
// =============================
router.get("/:userId", transactionController.getUserTransactions);

// =============================
// EXPORT
// =============================
module.exports = router;
