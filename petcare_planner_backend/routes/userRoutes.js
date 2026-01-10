const express = require("express");
const router = express.Router();

const { registerUser, loginUser } = require("../controllers/userController");

const {
  uploadMiddleware,
  uploadProfileImage,
} = require("../middleware/uploadUserImage");

const authMiddleware = require("../middleware/authMiddleware");

// --- Register User ---
router.post("/register", registerUser);

// --- Login User ---
router.post("/login", loginUser);

// --- Upload Profile Image ---
router.post(
  "/profile-image",
  authMiddleware,
  uploadMiddleware,
  uploadProfileImage
);

module.exports = router;
