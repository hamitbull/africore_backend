/**
 * ============================================
 * 📊 AFRICORE OS - ANALYTICS SERVICE
 * ============================================
 */

const Transaction = require("../../database/models/Transaction");
const User = require("../../database/models/User");
const MiniApp = require("../../database/models/MiniApp");

// =============================
// GET DASHBOARD STATS
// =============================
const getDashboardStats = async () => {
    // =============================
    // TOTAL USERS
    // =============================
    const totalUsers = await User.countDocuments();

    // =============================
    // TOTAL TRANSACTIONS
    // =============================
    const totalTransactions = await Transaction.countDocuments({
        status: "successful"
    });

    // =============================
    // TOTAL REVENUE (PLATFORM)
    // =============================
    const totalRevenueData = await Transaction.aggregate([
        {
            $match: {
                provider: "platform-fee",
                status: "successful"
            }
        },
        {
            $group: {
                _id: null,
                total: { $sum: "$amount" }
            }
        }
    ]);

    const totalRevenue = totalRevenueData[0]?.total || 0;

    // =============================
    // DAILY REVENUE
    // =============================
    const dailyRevenue = await Transaction.aggregate([
        {
            $match: {
                provider: "platform-fee",
                status: "successful"
            }
        },
        {
            $group: {
                _id: {
                    day: { $dayOfMonth: "$createdAt" },
                    month: { $month: "$createdAt" },
                    year: { $year: "$createdAt" }
                },
                total: { $sum: "$amount" }
            }
        },
        { $sort: { "_id.year": -1, "_id.month": -1, "_id.day": -1 } }
    ]);

    // =============================
    // TOP MINI APPS
    // =============================
    const topApps = await Transaction.aggregate([
        {
            $match: {
                provider: "miniapp",
                status: "successful"
            }
        },
        {
            $group: {
                _id: "$description",
                total: { $sum: "$amount" }
            }
        },
        { $sort: { total: -1 } },
        { $limit: 5 }
    ]);

    return {
        totalUsers,
        totalTransactions,
        totalRevenue,
        dailyRevenue,
        topApps
    };
};

module.exports = {
    getDashboardStats
};
