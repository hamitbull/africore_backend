const express = require("express");
const router = express.Router();

const controller = require("./kyc.controller");
const authMiddleware = require("../../middleware/auth.middleware");
const adminMiddleware = require("../../middleware/admin.middleware");

// User submit KYC
router.post("/submit", authMiddleware, controller.submit);

// Admin approve/reject
router.put("/approve/:id", authMiddleware, adminMiddleware, controller.approve);
router.put("/reject/:id", authMiddleware, adminMiddleware, controller.reject);

module.exports = router;
