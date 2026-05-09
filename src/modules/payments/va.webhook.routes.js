const express = require("express");
const router = express.Router();

const controller = require("./va.webhook.controller");

// ⚠️ No auth
router.post("/flutterwave/va", controller.handleVAWebhook);

module.exports = router;
