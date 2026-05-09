const express = require("express");
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const router = express.Router();

/**
 * AFRICORE OS - USER SYSTEM CORE
 * Handles:
 * - Register
 * - Login
 * - AFRO ID generation
 */

// ==========================
// 1. USER SCHEMA
// ==========================
const userSchema = new mongoose.Schema({
    name: String,
    phone: String,
    dob: String,
    afro_id: {
        type: String,
        unique: true
    },
    password: String,
    createdAt: {
        type: Date,
        default: Date.now
    }
});

const User = mongoose.model("User", userSchema);

// ==========================
// 2. AFRO ID GENERATOR
// ==========================
function generateAfroId(name) {
    const cleanName = name.toLowerCase().replace(/\s/g, "");
    const random = Math.floor(100 + Math.random() * 900);
    return `${cleanName}${random}@afro`;
}

// ==========================
// 3. REGISTER USER
// ==========================
router.post("/register", async (req, res) => {
    try {
        const { name, phone, dob, password } = req.body;

        // Check if user exists
        const existingUser = await User.findOne({ phone });
        if (existingUser) {
            return res.json({ message: "User already exists" });
        }

        // Generate AFRO ID
        const afro_id = generateAfroId(name);

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = await User.create({
            name,
            phone,
            dob,
            afro_id,
            password: hashedPassword
        });

        res.json({
            message: "Registration successful",
            afro_id: user.afro_id
        });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// ==========================
// 4. LOGIN USER
// ==========================
router.post("/login", async (req, res) => {
    try {
        const { afro_id, password } = req.body;

        // Find user
        const user = await User.findOne({ afro_id });
        if (!user) {
            return res.json({ message: "User not found" });
        }

        // Check password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.json({ message: "Invalid password" });
        }

        res.json({
            message: "Login successful",
            user: {
                name: user.name,
                afro_id: user.afro_id
            }
        });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
