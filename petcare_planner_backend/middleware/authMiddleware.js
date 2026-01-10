const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      message: "Unauthorized",
    });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.SECRET);

    req.user = {
      _id: decoded._id,
      email: decoded.email,
      username: decoded.username,
    };

    next();
  } catch (err) {
    console.log("JWT error:", err.message);
    return res.status(401).json({
      success: false,
      message: "Invalid Token",
    });
  }
};
