const mongoose = require("mongoose");
require("colors");

const CONNECTION_STRING = process.env.MONGODB_URI;

const connectDB = async () => {
  try {
    await mongoose.connect(CONNECTION_STRING);
    console.log(
      `Mongodb connected: ${mongoose.connection.name}`.white.underline.bold
    );
  } catch (err) {
    console.log("Database error".red.underline.bold);
    console.error(err.message.red);
  }
};

module.exports = connectDB;
