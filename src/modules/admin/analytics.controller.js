/**
 * ============================================
 * 📊 ANALYTICS CONTROLLER
 * ============================================
 */

const { getDashboardStats } = require("./analytics.service");

const getDashboard = async (req, res) => {
    try {
        const data = await getDashboardStats();

        return res.json({
            message: "Dashboard data fetched",
            data
        });

    } catch (error) {
        console.error("❌ ANALYTICS ERROR:", error.message);

        return res.status(500).json({
            message: "Failed to load dashboard"
        });
    }
};

module.exports = {
    getDashboard
};
