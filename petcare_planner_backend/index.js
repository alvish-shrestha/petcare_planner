require("dotenv").config();

const express = require("express");
const connectDB = require("./config/db");

const userRoute = require("./routes/userRoutes");

const cors = require("cors");

const app = express();

app.use(cors());

connectDB();

app.use(express.json());

app.use("/api/auth", userRoute);

module.exports = app;
