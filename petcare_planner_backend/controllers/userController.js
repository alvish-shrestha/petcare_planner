const User = require("../models/User");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.registerUser = async (req, res) => {
  const { username, email, password, confirmPassword } = req.body;
  console.log(req.body);

  // check empty fields
  if (!username || !email || !password || !confirmPassword) {
    return res.status(400).json({
      success: "false",
      message: "Please fill all the fields",
    });
  }

  // Check if passwords match
  if (password != confirmPassword) {
    return res.status(400).json({
      success: false,
      message: "Passwords do not match",
    });
  }

  const passwordRegex =
    /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/;
  if (!passwordRegex.test(password)) {
    return res.status(400).json({
      success: false,
      message:
        "Password must be at least 6 characters, include 1 uppercase letter, 1 number, and 1 special character",
    });
  }

  try {
    // Check if user exists
    const existingUser = await User.findOne({
      $or: [{ username: username }, { email: email }],
    });

    if (existingUser) {
      return res.status(400).json({
        success: "false",
        message: "User exists",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      username: username.toLowerCase(),
      email: email.toLowerCase(),
      password: hashedPassword,
    });

    await newUser.save();

    return res.status(201).json({
      success: true,
      message: "User registered!",
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: "Missing Field",
    });
  }

  try {
    const getUser = await User.findOne({
      email: email,
    });

    if (!getUser) {
      return res.status(400).json({
        success: false,
        message: "User missing",
      });
    }

    // check password
    const passwordCheck = await bcrypt.compare(password, getUser.password);
    if (!passwordCheck) {
      return res.status(400).json({
        success: false,
        message: "Invalid Password",
      });
    }

    // jwt
    const payload = {
      _id: getUser._id,
      email: getUser.email,
      username: getUser.username,
    };

    const token = jwt.sign(payload, process.env.SECRET, { expiresIn: "7d" });

    return res.status(200).json({
      success: true,
      message: "Login successful",
      data: {
        _id: getUser._id,
        username: getUser.username,
        email: getUser.email,
      },
      token: token,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};
