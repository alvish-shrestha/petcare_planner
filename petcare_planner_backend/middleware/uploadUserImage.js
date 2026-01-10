const multer = require("multer");
const path = require("path");
const User = require("../models/User");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/profiles/");
  },
  filename: function (req, file, cb) {
    cb(null, req.user._id + "-" + Date.now() + path.extname(file.originalname));
  },
});

const allowedExtensions = /jpeg|jpg|png|heic|heif/;
const allowedMimeTypes = [
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/heic",
  "image/heif",
];

const fileFilter = (req, file, cb) => {
  console.log("file.originalname:", file.originalname);
  console.log("file.mimetype:", file.mimetype);

  const extname = allowedExtensions.test(
    path.extname(file.originalname).toLowerCase()
  );

  const mimetype = allowedMimeTypes.includes(file.mimetype);

  if ((mimetype || file.mimetype === "application/octet-stream") && extname) {
    cb(null, true);
  } else {
    cb(new Error("Only .jpeg, .jpg, .png, .heic and .heif images are allowed"));
  }
};

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter,
});

exports.uploadMiddleware = upload.single("profileImage");

exports.uploadProfileImage = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "No file uploaded",
      });
    }

    const imageUrl = `/uploads/profiles/${req.file.filename}`;

    await User.findByIdAndUpdate(req.user._id, {
      profileImageUrl: imageUrl,
    });

    return res.status(200).json({
      success: true,
      imageUrl,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};
