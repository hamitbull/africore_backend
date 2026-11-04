const express = require("express");
const router = express.Router();

const paymentController = require("./payment.controller");
const authMiddleware = require("../../middleware/auth.middleware");

router.post("/initiate", authMiddleware, paymentController.startPayment);
router.post("/verify", authMiddleware, paymentController.verifyUserPayment);

module.exports = router;
