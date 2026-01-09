const mongoose = require("mongoose");

const BadgeSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    icon: {
      type: String,
      required: true,
    },
    description: {
      type: String,
    },
    criteria: {
      type: String,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Badge", BadgeSchema);
