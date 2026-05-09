const express = require("express");
const cors = require("cors");

const userSystem = require("./userSystem");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/user", userSystem);

// Test route
app.get("/", (req, res) => {
    res.json({
        message: "AFRICORE OS Backend Running 🚀"
    });
});

module.exports = app;
