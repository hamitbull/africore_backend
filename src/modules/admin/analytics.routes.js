const express = require("express");
const router = express.Router();

const controller = require("./analytics.controller");
const authMiddleware = require("../../middleware/auth.middleware");
const adminMiddleware = require("../../middleware/admin.middleware");

router.get("/dashboard", authMiddleware, adminMiddleware, controller.getDashboard);

module.exports = router;
