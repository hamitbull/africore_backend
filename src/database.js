const mongoose = require("mongoose");
require("dotenv").config();

/**
 * AFRICORE OS - DATABASE CORE FILE
 * Handles all database connection
 * Production ready single file
 */

const connectDB = async () => {
    try {
        // Connect to MongoDB
        const conn = await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        console.log("🟢 AFRICORE DATABASE CONNECTED SUCCESSFULLY");
        console.log("📦 Host:", conn.connection.host);
        console.log("🗄️ Database:", conn.connection.name);

    } catch (error) {
        console.log("🔴 AFRICORE DATABASE CONNECTION FAILED");
        console.error(error.message);

        // Stop server if database fails
        process.exit(1);
    }
};

module.exports = connectDB;
