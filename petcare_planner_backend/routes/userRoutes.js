const express = require("express");
const router = express.Router();

const {
  registerUser,
  loginUser,
  updateProfile,
  changePassword,
  deleteUser,
  sendResetLink,
  verifyOtp,
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

/// --- Send OTP Code ---
router.post("/forgot-password", sendResetLink);

/// --- Verify OTP Code ---
router.post("/verify-otp", verifyOtp);

/// --- Reset Password ---
router.post("/reset-password", resetPassword);

// --- Upload Profile Image ---
router.post(
  "/profile-image",
  authMiddleware,
  uploadMiddleware,
  uploadProfileImage
);

module.exports = router;
