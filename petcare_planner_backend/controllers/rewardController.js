const Badge = require("../models/Badge");
const UserBadge = require("../models/UserBadge");
const Milestone = require("../models/Milestone");

// --- SUMMARY ---
exports.getRewardSummary = async (req, res) => {
  try {
    const userId = req.user._id;

    const totalBadges = await Badge.countDocuments();
    const unlocked = await UserBadge.countDocuments({ userId });

    return res.status(200).json({
      success: true,
      data: {
        totalBadges,
        unlocked,
        toUnlock: totalBadges - unlocked,
      },
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// --- USER BADGES ---
exports.getUserBadges = async (req, res) => {
  try {
    const userBadges = await UserBadge.find({ userId: req.user._id })
      .populate("badgeId", "title icon description")
      .sort({ unlockedAt: -1 });

    return res.status(200).json({
      success: true,
      data: userBadges,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// --- MILESTONES ---
exports.getMilestones = async (req, res) => {
  try {
    const milestones = await Milestone.find({ userId: req.user._id }).sort({
      achievedAt: -1,
    });

    return res.status(200).json({
      success: true,
      data: milestones,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};
