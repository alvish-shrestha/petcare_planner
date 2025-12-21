const Task = require("../models/Task");
const mongoose = require("mongoose");

// --- Create Task ---
exports.createTask = async (req, res) => {
  try {
    const {
      taskTitle,
      petId,
      taskType,
      date,
      time,
      repeat = "None",
      notes,
      reminder = true,
    } = req.body;

    if (!taskTitle || !petId || !taskType || !date || !time) {
      return res.status(400).json({
        success: false,
        message: "Please provide all required fields",
      });
    }

    const validTypes = ["Feeding", "Walking", "Grooming", "Medical"];
    if (!validTypes.includes(taskType)) {
      return res.status(400).json({
        success: false,
        message: "Invalid task type",
      });
    }

    const validRepeats = ["None", "Daily", "Weekly", "Monthly"];
    if (!validRepeats.includes(repeat)) {
      return res.status(400).json({
        success: false,
        message: "Invalid repeat value",
      });
    }

    if (!mongoose.Types.ObjectId.isValid(petId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid petId",
      });
    }

    const parsedDate = new Date(date);
    if (isNaN(parsedDate.getTime())) {
      return res.status(400).json({
        success: false,
        message: "Invalid date format",
      });
    }

    const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/;
    if (!timeRegex.test(time)) {
      return res.status(400).json({
        success: false,
        message: "Invalid time format. Use HH:mm (24-hour format)",
      });
    }

    const newTask = new Task({
      taskTitle,
      petId,
      taskType,
      date: parsedDate,
      time,
      repeat,
      notes,
      reminder,
    });

    await newTask.save();

    return res.status(201).json({
      success: true,
      message: "Task created successfully",
      task: newTask,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// --- Get All Tasks ---
exports.getAllTasks = async (req, res) => {
  try {
    const filter = {};

    if (req.query.petId) {
      if (!mongoose.Types.ObjectId.isValid(req.query.petId)) {
        return res.status(400).json({
          success: false,
          message: "Invalid petId filter",
        });
      }
      filter.petId = req.query.petId;
    }

    const tasks = await Task.find(filter).populate("petId");

    return res.status(200).json({
      success: true,
      tasks,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// --- Get task by ID ---
exports.getTaskById = async (req, res) => {
  try {
    const taskId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(taskId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid task ID",
      });
    }

    const task = await Task.findById(taskId).populate("petId");

    if (!task) {
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    return res.status(200).json({
      success: true,
      task,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// --- Update task by ID ---
exports.updateTask = async (req, res) => {
  try {
    const taskId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(taskId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid task ID",
      });
    }

    const updateData = {};
    const { taskTitle, petId, taskType, date, time, repeat, notes, reminder } =
      req.body;

    if (taskTitle !== undefined) updateData.taskTitle = taskTitle;

    if (petId !== undefined) {
      if (!mongoose.Types.ObjectId.isValid(petId)) {
        return res.status(400).json({
          success: false,
          message: "Invalid petId",
        });
      }
      updateData.petId = petId;
    }

    if (taskType !== undefined) {
      const validTypes = ["Feeding", "Walking", "Grooming", "Medical"];
      if (!validTypes.includes(taskType)) {
        return res.status(400).json({
          success: false,
          message: "Invalid task type",
        });
      }
      updateData.taskType = taskType;
    }

    if (date !== undefined) {
      const parsedDate = new Date(date);
      if (isNaN(parsedDate.getTime())) {
        return res.status(400).json({
          success: false,
          message: "Invalid date format",
        });
      }
      updateData.date = parsedDate;
    }

    if (time !== undefined) updateData.time = time;

    if (repeat !== undefined) {
      const validRepeats = ["None", "Daily", "Weekly", "Monthly"];
      if (!validRepeats.includes(repeat)) {
        return res.status(400).json({
          success: false,
          message: "Invalid repeat value",
        });
      }
      updateData.repeat = repeat;
    }

    if (notes !== undefined) updateData.notes = notes;

    if (reminder !== undefined) updateData.reminder = reminder;

    const updatedTask = await Task.findByIdAndUpdate(taskId, updateData, {
      new: true,
    }).populate("petId");

    if (!updatedTask) {
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Task updated successfully",
      task: updatedTask,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

// --- Delete task by ID ---
exports.deleteTask = async (req, res) => {
  try {
    const taskId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(taskId)) {
      return res.status(400).json({
        success: false,
        message: "Invalid task ID",
      });
    }

    const deletedTask = await Task.findByIdAndDelete(taskId);

    if (!deletedTask) {
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Task deleted successfully",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};
