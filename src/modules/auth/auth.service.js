const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const env = require("../../config/env");
const User = require("../../database/models/User");
const { createWallet } = require("../wallet/wallet.service");

const createAfroId = async (name) => {
    const cleanName = String(name)
        .toLowerCase()
        .replace(/[^a-z0-9]/g, "")
        .slice(0, 18) || "member";

    for (let attempt = 0; attempt < 8; attempt += 1) {
        const suffix = Math.floor(100000 + Math.random() * 900000);
        const afroId = `${cleanName}${suffix}@afro`;
        const exists = await User.exists({ afro_id: afroId });
        if (!exists) return afroId;
    }
    throw new Error("Could not allocate a unique AFRICORE ID. Please retry.");
};

const createToken = (user) => jwt.sign(
    { id: user._id.toString(), role: user.role },
    env.JWT_SECRET,
    { expiresIn: "7d" }
);

const publicUser = (user) => ({
    id: user._id,
    name: user.name,
    email: user.email || null,
    phone: user.phone,
    afro_id: user.afro_id,
    role: user.role,
    kycStatus: user.kycStatus
});

const registerUserService = async (data = {}) => {
    const name = String(data.name || data.fullName || "").trim();
    const phone = String(data.phone || "").trim();
    const email = String(data.email || "").trim().toLowerCase();
    const password = String(data.password || "");
    const dob = data.dob || undefined;

    if (!name || !phone || !password) {
        throw new Error("Name, phone number and password are required.");
    }
    if (password.length < 8) {
        throw new Error("Password must contain at least 8 characters.");
    }

    const duplicate = await User.findOne({
        $or: [
            { phone },
            ...(email ? [{ email }] : [])
        ]
    });
    if (duplicate) {
        throw new Error("A user with this phone number or email already exists.");
    }

    const afro_id = await createAfroId(name);
    const hashedPassword = await bcrypt.hash(password, 12);
    const user = await User.create({
        name,
        phone,
        ...(email ? { email } : {}),
        dob,
        afro_id,
        password: hashedPassword
    });

    try {
        const wallet = await createWallet(user._id);
        user.walletId = wallet._id;
        await user.save();
    } catch (error) {
        await User.deleteOne({ _id: user._id });
        throw new Error("Could not initialize your wallet. Please try again.");
    }

    return {
        message: "Registration successful",
        token: createToken(user),
        user: publicUser(user)
    };
};

const loginUserService = async (data = {}) => {
    const identifier = String(data.phone || data.afro_id || data.email || "").trim();
    const password = String(data.password || "");
    if (!identifier || !password) {
        throw new Error("Phone number or AFRICORE ID and password are required.");
    }

    const user = await User.findOne({
        $or: [
            { phone: identifier },
            { afro_id: identifier },
            { email: identifier.toLowerCase() }
        ]
    });
    if (!user || !(await bcrypt.compare(password, user.password))) {
        throw new Error("Invalid login details.");
    }

    return {
        message: "Login successful",
        token: createToken(user),
        user: publicUser(user)
    };
};

const getCurrentUserService = async (userId) => {
    if (!userId) throw new Error("Authenticated user is missing.");
    const user = await User.findById(userId).select("-password");
    if (!user) throw new Error("User not found.");
    return { user };
};

module.exports = {
    registerUserService,
    loginUserService,
    getCurrentUserService
};
