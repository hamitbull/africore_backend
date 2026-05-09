/**
 * ============================================
 * 🔐 AFRICORE OS - AUTH CONTROLLER
 * ============================================
 * Handles incoming requests & responses
 */

const {
    registerUserService,
    loginUserService,
    getCurrentUserService
} = require("./auth.service");

// Register
const registerUser = async (req, res) => {
    try {
        const result = await registerUserService(req.body);
        return res.status(201).json(result);
    } catch (error) {
        console.error("REGISTER ERROR:", error.message);
        return res.status(400).json({ message: error.message });
    }
};

// Login
const loginUser = async (req, res) => {
    try {
        const result = await loginUserService(req.body);
        return res.json(result);
    } catch (error) {
        console.error("LOGIN ERROR:", error.message);
        return res.status(400).json({ message: error.message });
    }
};

// Get current user
const getCurrentUser = async (req, res) => {
    try {
        const result = await getCurrentUserService();
        return res.json(result);
    } catch (error) {
        console.error("PROFILE ERROR:", error.message);
        return res.status(500).json({ message: "Server error" });
    }
};


// Export
module.exports = {
    registerUser,
    loginUser,
    getCurrentUser
};
