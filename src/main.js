/**
 * ============================================
 * 🚀 AFRICORE OS - MAIN ENTRY FILE
 * ============================================
 * Starts server, connects DB, loads modules
 */

const express = require("express");
const cors = require("cors");

// Load ENV config
const env = require("./config/env");

// Database connection
const connectDB = require("./config/database");

// Flutterwave config validation
const { validateFlutterwaveConfig } = require("./config/flutterwave.config");

// =============================
// INIT APP
// =============================
const app = express();

// =============================
// GLOBAL MIDDLEWARE
// =============================
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// =============================
// HEALTH CHECK ROUTE
// =============================
app.get("/", (req, res) => {
    res.json({
        status: "OK",
        message: "AFRICORE OS Backend Running 🚀"
    });
});

// =============================
// LOAD ROUTES (MODULES)
// =============================

// AUTH ROUTES
const authRoutes = require("./modules/auth/auth.routes");
app.use("/api/auth", authRoutes);

// (Future)
 //const walletRoutes = require("./modules/wallet/wallet.routes");
 // app.use("/api/wallet", walletRoutes);
const transactionRoutes = require("./modules/wallet/transaction.routes");

app.use("/api/transactions", transactionRoutes);

const walletRoutes = require("./modules/wallet/wallet.routes");

app.use("/api/wallet", walletRoutes);

 const paymentRoutes = require("./modules/payments/payment.routes");
  app.use("/api/payment", paymentRoutes);

const payoutRoutes = require("./modules/admin/payout.routes");

app.use("/api/payout", payoutRoutes);

const kycRoutes = require("./modules/kyc/kyc.routes");

app.use("/api/kyc", kycRoutes);

const vaWebhookRoutes = require("./modules/payments/va.webhook.routes");

app.use("/api/webhook", vaWebhookRoutes);

//  const miniAppRoutes = require("./modules/miniapps/miniapp.routes");
//  app.use("/api/miniapps", miniAppRoutes);

const transferRoutes = require("./modules/wallet/transfer.routes");

app.use("/api/transfer", transferRoutes);

const miniAppPaymentRoutes = require("./modules/miniapp/miniapp.payment.routes");

app.use("/api/miniapp", miniAppPaymentRoutes);

const analyticsRoutes = require("./modules/admin/analytics.routes");

app.use("/api/admin", analyticsRoutes);

const miniAppRoutes = require("./modules/miniapp/miniapp.routes");

app.use("/api/miniapps", miniAppRoutes);

const notificationRoutes = require("./modules/notifications/notification.routes");

app.use("/api/notifications", notificationRoutes);

const webhookRoutes = require("./modules/payments/webhook.routes");

app.use("/api/webhook", webhookRoutes);

// =============================
// ERROR HANDLER (GLOBAL)
// =============================
app.use((err, req, res, next) => {
    console.error("❌ ERROR:", err.message);

    res.status(500).json({
        message: "Internal Server Error"
    });
});

// =============================
// START SERVER FUNCTION
// =============================
const startServer = async () => {
    try {
        // Connect Database
        await connectDB();

        // Validate payment config
        validateFlutterwaveConfig();

        // Start server
        app.listen(env.PORT, () => {
            console.log("🚀 AFRICORE SERVER STARTED");
            console.log(`🌍 PORT: ${env.PORT}`);
            console.log(`🛠️ MODE: ${env.NODE_ENV}`);
        });

    } catch (error) {
        console.error("❌ FAILED TO START SERVER");
        console.error(error);
        process.exit(1);
    }
};

// =============================
// RUN SERVER
// =============================
startServer();
