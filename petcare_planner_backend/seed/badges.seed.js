const mongoose = require("mongoose");
require("dotenv").config();

const Badge = require("../models/Badge");
const connectDB = require("../config/db");

connectDB();

const badges = [
  {
    title: "First Pet",
    icon: "🐾",
    description: "Added your first pet",
  },
  {
    title: "Walking Hero",
    icon: "❤️",
    description: "Completed 10 walks",
  },
  {
    title: "Task Starter",
    icon: "✅",
    description: "Completed your first task",
  },
];

(async () => {
  await Badge.deleteMany();
  await Badge.insertMany(badges);
  console.log("Badges Seeded");
  process.exit();
})();
