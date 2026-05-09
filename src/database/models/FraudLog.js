const mongoose = require("mongoose");

const fraudLogSchema = new mongoose.Schema({
    userId: mongoose.Schema.Types.ObjectId,
    reason: String,
    amount: Number
}, { timestamps: true });

module.exports = mongoose.model("FraudLog", fraudLogSchema);
