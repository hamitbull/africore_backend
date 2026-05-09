/**
 * ============================================
 * 📱 MINI APP CONTROLLER
 * ============================================
 */

const {
    createMiniApp,
    getActiveApps
} = require("./miniapp.service");

// =============================
// SUBMIT APP
// =============================
const submitApp = async (req, res) => {
    try {
        const app = await createMiniApp(req.body, req.user.id);

        return res.status(201).json({
            message: "App submitted for review",
            app
        });

    } catch (error) {
        console.error(error.message);

        return res.status(400).json({
            message: error.message
        });
    }
};

// =============================
// FETCH APPS
// =============================
const fetchApps = async (req, res) => {
    try {
        const apps = await getActiveApps();

        return res.json(apps);

    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch apps"
        });
    }
};

module.exports = {
    submitApp,
    fetchApps
};
