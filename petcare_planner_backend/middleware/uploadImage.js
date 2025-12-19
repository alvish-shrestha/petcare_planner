const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
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
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: fileFilter,
});

module.exports = upload;
