/**
 * ============================================
 * 🗄️ AFRICORE OS - DATABASE CONNECTION
 * ============================================
 * Handles MongoDB connection using Mongoose
 */

const mongoose = require("mongoose");
const env = require("./env");

// =============================
// CONNECT DATABASE FUNCTION
// =============================
const connectDB = async () => {
    try {
        const conn = await mongoose.connect(env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        console.log("🟢 DATABASE CONNECTED SUCCESSFULLY");
        console.log(`📦 HOST: ${conn.connection.host}`);
        console.log(`🗄️ DB NAME: ${conn.connection.name}`);

    } catch (error) {
        console.error("🔴 DATABASE CONNECTION FAILED");
        console.error(error.message);

        // Stop server if DB fails
        process.exit(1);
    }
};

// =============================
// EXPORT FUNCTION
// =============================
module.exports = connectDB;
