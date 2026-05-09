const bcrypt = require("bcryptjs");
const User = require("../../database/models/User");

// Generate Afro ID
const generateAfroId = (name) => {
    const clean = name.toLowerCase().replace(/\s/g, "");
    const random = Math.floor(1000 + Math.random() * 9000);
    return `${clean}${random}@afro`;
};

// Register
const registerUserService = async (data) => {
    const { name, phone, dob, password } = data;

const va = await createVirtualAccount(user);

    if (!name || !phone || !password) {
        throw new Error("Missing required fields");
    };       



    const existingUser = await User.findOne({ phone });
    if (existingUser) {
        throw new Error("User already exists");
    }

const { createVirtualAccount } = require("../payments/flutterwave.va.service");

// AFTER USER CREATED
//const va = await createVirtualAccount(user);

//user.virtualAccount = va;
//await user.save();


    const afro_id = generateAfroId(name);

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
        name,
        phone,
        dob,
        afro_id,
        password: hashedPassword
    });
//const va = await createVirtualAccount(user);

    return {
        message: "Registration successful",
        afro_id: user.afro_id
    };
};

// Login
const loginUserService = async (data) => {
    const { afro_id, password } = data;

//const va = await createVirtualAccount(user);

    if (!afro_id || !password) {
        throw new Error("Missing credentials");
    }

    const user = await User.findOne({ afro_id });
    if (!user) {
        throw new Error("User not found");
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        throw new Error("Invalid password");
    }

    return {
        message: "Login successful",
        user: {
            name: user.name,
            afro_id: user.afro_id
        }
    };
};

  
const Wallet = require("../../database/models/Wallet");


// Get current user
const getCurrentUserService = async () => {
    return {
        message: "User profile service working"
    };
};
 
//const { createVirtualAccount } = require("../payments/flutterwave.va.service");

// AFTER USER CREATED
//const va = await createVirtualAccount(user);

//user.virtualAccount = va;
//await user.save();

module.exports = {
    registerUserService,
    loginUserService,
    getCurrentUserService
};

