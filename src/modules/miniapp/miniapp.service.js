/**
 * ============================================
 * 📱 MINI APP SERVICE
 * ============================================
 */

const MiniApp = require("../../database/models/MiniApp");

// =============================
// CREATE MINI APP
// =============================
const createMiniApp = async (data, developerId) => {
    const app = await MiniApp.create({
        ...data,
        developerId,
        isActive: false
    });

    return app;
};

// =============================
// GET ALL ACTIVE APPS
// =============================
const getActiveApps = async () => {
    return await MiniApp.find({ isActive: true });
};

// =============================
// GET SINGLE APP
// =============================
const getSingleApp = async (appId) => {
    const app = await MiniApp.findById(appId);

    if (!app) {
        throw new Error("App not found");
    }

    return app;
};

module.exports = {
    createMiniApp,
    getActiveApps,
    getSingleApp
};
