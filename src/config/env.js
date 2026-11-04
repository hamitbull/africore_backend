require("dotenv").config();

const requiredEnv = ["PORT", "MONGO_URI", "JWT_SECRET", "FLW_SECRET_KEY"];
for (const key of requiredEnv) {
    if (!process.env[key]) {
        console.error(`Missing required environment variable: ${key}`);
        process.exit(1);
    }
}

if (String(process.env.JWT_SECRET).length < 32) {
    console.error("JWT_SECRET must contain at least 32 characters.");
    process.exit(1);
}

module.exports = {
    PORT: process.env.PORT || 5000,
    NODE_ENV: process.env.NODE_ENV || "development",
    MONGO_URI: process.env.MONGO_URI,
    JWT_SECRET: process.env.JWT_SECRET,
    FLW_SECRET_KEY: process.env.FLW_SECRET_KEY,
    FLW_PUBLIC_KEY: process.env.FLW_PUBLIC_KEY,
    FLW_ENCRYPTION_KEY: process.env.FLW_ENCRYPTION_KEY,
    FLW_WEBHOOK_SECRET: process.env.FLW_WEBHOOK_SECRET || "",
    FCM_SERVER_KEY: process.env.FCM_SERVER_KEY,
    APP_NAME: process.env.APP_NAME || "AFRICORE",
    APP_URL: process.env.APP_URL || ""
};
