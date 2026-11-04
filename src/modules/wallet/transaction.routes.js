const express = require("express");
const router = express.Router();

const transactionController = require("./transaction.controller");
const authMiddleware = require("../../middleware/auth.middleware");

router.get("/me", authMiddleware, transactionController.getMyTransactions);

module.exports = router;
