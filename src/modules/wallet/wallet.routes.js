const express = require("express");
const router = express.Router();

const walletController = require("./wallet.controller");
const authMiddleware = require("../../middleware/auth.middleware");
const adminMiddleware = require("../../middleware/admin.middleware");

// Users can only read their own wallet.
router.get("/me", authMiddleware, walletController.getMyWallet);

// Administrative wallet operations require both authentication and admin role.
router.post("/create", authMiddleware, adminMiddleware, walletController.createUserWallet);
router.post("/credit", authMiddleware, adminMiddleware, walletController.creditUserWallet);
router.post("/debit", authMiddleware, adminMiddleware, walletController.debitUserWallet);

module.exports = router;
