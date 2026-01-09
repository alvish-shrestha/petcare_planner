const express = require("express");
const router = express.Router();

const auth = require("../middleware/authMiddleware");
const {
  getRewardSummary,
  getUserBadges,
  getMilestones,
} = require("../controllers/rewardController");

router.get("/summary", auth, getRewardSummary);
router.get("/badges", auth, getUserBadges);
router.get("/milestones", auth, getMilestones);

module.exports = router;
