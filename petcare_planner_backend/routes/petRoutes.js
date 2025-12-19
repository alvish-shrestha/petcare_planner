const express = require("express");
const { addPet } = require("../controllers/petController");
const upload = require("../middleware/uploadImage");
const router = express.Router();

router.post("/add-pet", upload.single("petImage"), addPet);

module.exports = router;
