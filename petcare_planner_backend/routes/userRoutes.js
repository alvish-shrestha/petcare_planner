const express = require("express");
const router = express.Router();

const {
  registerUser,
  loginUser,
  updateProfile,
  changePassword,
  deleteUser,
  sendResetLink,
  resetPassword,
} = require("../controllers/userController");

const {
  uploadMiddleware,
  uploadProfileImage,
} = require("../middleware/uploadUserImage");

const authMiddleware = require("../middleware/authMiddleware");

/// --- Register User ---
router.post("/register", registerUser);

/// --- Login User ---
router.post("/login", loginUser);

/// --- Update User Profile ---
router.put("/updateProfile", authMiddleware, updateProfile);

/// --- Change Password ---
router.put("/change-password", authMiddleware, changePassword);

/// --- Delete User Profile ---
router.delete("/deleteUser", authMiddleware, deleteUser);

/// --- Request link sent ---
router.post("/request-reset", sendResetLink);

/// --- Reset Password ---
router.post("/reset-password/:token", resetPassword);

// --- Upload Profile Image ---
router.post(
  "/profile-image",
  authMiddleware,
  uploadMiddleware,
  uploadProfileImage
);

module.exports = router;
