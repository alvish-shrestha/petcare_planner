const mongoose = require("mongoose");

const PetSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    petImage: {
      type: String,
      required: true,
    },
    petType: {
      type: String,
      enum: ["Dog", "Cat", "Other"],
      required: true,
    },
    petName: {
      type: String,
      required: true,
    },
    breed: {
      type: String,
      required: true,
    },
    age: {
      type: Number,
      required: true,
    },
    gender: {
      type: String,
      enum: ["Male", "Female"],
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Pet", PetSchema);
