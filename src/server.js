require("dotenv").config();
const app = require("./app");
const connectDB = require("./database");

// CONNECT DATABASE FIRST
connectDB();

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log("🚀 AFRICORE BACKEND RUNNING");
    console.log("🌍 PORT:", PORT);
});
