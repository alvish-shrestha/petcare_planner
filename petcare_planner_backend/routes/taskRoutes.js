const express = require("express");
const {
  createTask,
  getAllTasks,
  getTaskById,
  updateTask,
  deleteTask,
} = require("../controllers/taskController");
const router = express.Router();

// --- Create Task ---
router.post("/create-task", createTask);

// --- Get all task ---
router.get("/get-all-task", getAllTasks);

// -- Get task by ID
router.get("/get-task-by-id/:id", getTaskById);

// --- Update task ---
router.put("/update-task/:id", updateTask);

// --- Delete task ---
router.delete("/delete-task/:id", deleteTask);

module.exports = router;
