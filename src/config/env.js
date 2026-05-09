/**
 * ============================================
 * ⚙️ AFRICORE OS - ENV CONFIG MANAGER
 * ============================================
 * Loads and validates environment variables
 */

require("dotenv").config();

// =============================
// REQUIRED VARIABLES
// =============================
const requiredEnv = [
    "PORT",
    "MONGO_URI",
    "JWT_SECRET",
    "FLW_SECRET_KEY"
];

// =============================
// VALIDATE ENV VARIABLES
// =============================
requiredEnv.forEach((key) => {
    if (!process.env[key]) {
        console.error(`🔴 Missing ENV variable: ${key}`);
        process.exit(1);
    }
});

// =============================
// EXPORT CLEAN CONFIG
// =============================
const env = {
    PORT: process.env.PORT,
    NODE_ENV: process.env.NODE_ENV || "development",

    // Database
    MONGO_URI: process.env.MONGO_URI,

    // Auth
    JWT_SECRET: process.env.JWT_SECRET,

    // Payments
    FLW_SECRET_KEY: process.env.FLW_SECRET_KEY,
    FLW_PUBLIC_KEY: process.env.FLW_PUBLIC_KEY,
    FLW_ENCRYPTION_KEY: process.env.FLW_ENCRYPTION_KEY,

    // Notifications
    FCM_SERVER_KEY: process.env.FCM_SERVER_KEY,

    // App
    APP_NAME: process.env.APP_NAME,
    APP_URL: process.env.APP_URL
};

module.exports = env;
