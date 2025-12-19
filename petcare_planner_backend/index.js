require("dotenv").config();

const express = require("express");
const connectDB = require("./config/db");

const path = require("path");

const userRoute = require("./routes/userRoutes");
const petRoute = require("./routes/petRoutes");

const cors = require("cors");

const app = express();
app.use(cors());

// Connect to MongoDB
connectDB();

app.use(express.json());

// Serve uploads folder statically to access pet images
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// ------------------ Routes ------------------
// --- User Routes ---
app.use("/api/auth", userRoute);

// --- Pet Routes ---
app.use("/api/pet", petRoute);

module.exports = app;
