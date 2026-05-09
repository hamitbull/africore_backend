/**
 * ============================================
 * 🔐 AFRICORE OS - AUTH MIDDLEWARE
 * ============================================
 * Protects routes using JWT authentication
 */

const jwt = require("jsonwebtoken");
const env = require("../config/env");
const User = require("../database/models/User");

// =============================
// AUTH MIDDLEWARE
// =============================
const authMiddleware = async (req, res, next) => {
    try {
        let token;

        // =============================
        // GET TOKEN FROM HEADER
        // =============================
        if (
            req.headers.authorization &&
            req.headers.authorization.startsWith("Bearer")
        ) {
            token = req.headers.authorization.split(" ")[1];
        }

        // =============================
        // CHECK TOKEN
        // =============================
        if (!token) {
            return res.status(401).json({
                message: "No token, authorization denied"
            });
        }

        // =============================
        // VERIFY TOKEN
        // =============================
        const decoded = jwt.verify(token, env.JWT_SECRET);

        // =============================
        // FIND USER
        // =============================
        const user = await User.findById(decoded.id).select("-password");

        if (!user) {
            return res.status(401).json({
                message: "User not found"
            });
        }

        // =============================
        // ATTACH USER TO REQUEST
        // =============================
        req.user = user;

        next();

    } catch (error) {
        console.error("❌ AUTH ERROR:", error.message);

        return res.status(401).json({
            message: "Invalid or expired token"
        });
    }
};

// =============================
// EXPORT
// =============================
module.exports = authMiddleware;
