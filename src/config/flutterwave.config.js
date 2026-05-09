/**
 * AFRICORE OS - FLUTTERWAVE CONFIG
 * Handles all Flutterwave setup & base request config
 */

const axios = require("axios");
const env = require("./env");

// =============================
// BASE CONFIG
// =============================
const FLW_BASE_URL = "https://api.flutterwave.com/v3";

const headers = {
    Authorization: `Bearer ${env.FLW_SECRET_KEY}`,
    "Content-Type": "application/json"
};

// =============================
// AXIOS INSTANCE
// =============================
const flw = axios.create({
    baseURL: FLW_BASE_URL,
    headers: headers,
    timeout: 30000 // 30 seconds timeout
});

// =============================
// HELPER: VERIFY CONFIG
// =============================
const validateFlutterwaveConfig = () => {
    if (!env.FLW_SECRET_KEY) {
        console.error("🔴 Flutterwave Secret Key is missing in ENV");
        process.exit(1);
    }
};

// =============================
// EXPORT
// =============================
module.exports = {
    flw,
    validateFlutterwaveConfig
};
