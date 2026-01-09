const express = require("express");
const {
  createTask,
  getAllTasks,
  getTaskById,
  updateTask,
  deleteTask,
} = require("../controllers/taskController");
const authMiddleware = require("../middleware/authMiddleware");
const router = express.Router();

// --- Create Task ---
router.post("/create-task", authMiddleware, createTask);

// --- Get all task ---
router.get("/get-all-task", authMiddleware, getAllTasks);

// -- Get task by ID
router.get("/get-task-by-id/:id", authMiddleware, getTaskById);

// --- Update task ---
router.put("/update-task/:id", authMiddleware, updateTask);

// --- Delete task ---
router.delete("/delete-task/:id", authMiddleware, deleteTask);

module.exports = router;
