/**
 * ============================================
 * 🔐 AFRICORE OS - AUTH ROUTES
 * ============================================
 * Defines all authentication endpoints
 */

const express = require("express");
const router = express.Router();

// Import controller
const authController = require("./auth.controller");

// =============================
// AUTH ROUTES
// =============================

// 🟢 Register new user
// POST /api/auth/register
router.post("/register", authController.registerUser);

// 🔐 Login user with AFRO ID
// POST /api/auth/login
router.post("/login", authController.loginUser);

// 👤 Get current user (protected - will add middleware later)
// GET /api/auth/me
router.get("/me", authController.getCurrentUser);

//router.get("/me/:userId", getCurrentUser);

// =============================
// EXPORT ROUTER
// =============================
module.exports = router;

