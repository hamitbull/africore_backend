const {
    registerUserService,
    loginUserService,
    getCurrentUserService
} = require("./auth.service");

const registerUser = async (req, res) => {
    try {
        const result = await registerUserService(req.body);
        return res.status(201).json(result);
    } catch (error) {
        const status = /already exists|already|unique/i.test(error.message) ? 409 : 400;
        return res.status(status).json({ message: error.message });
    }
};

const loginUser = async (req, res) => {
    try {
        const result = await loginUserService(req.body);
        return res.status(200).json(result);
    } catch (error) {
        return res.status(401).json({ message: error.message });
    }
};

const getCurrentUser = async (req, res) => {
    try {
        const result = await getCurrentUserService(req.user._id);
        return res.status(200).json(result);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
};

module.exports = {
    registerUser,
    loginUser,
    getCurrentUser
};
