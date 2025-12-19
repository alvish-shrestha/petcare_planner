const express = require("express");
const {
  addPet,
  getAllPets,
  getPetById,
  updatePet,
  deletePet,
} = require("../controllers/petController");
const upload = require("../middleware/uploadImage");
const router = express.Router();

// --- Add Pet Details ---
router.post("/add-pet", upload.single("petImage"), addPet);

// --- Get All Pets --
router.get("/get-all-pet", upload.single("petImage"), getAllPets);

// --- Get pet by id ---
router.get("/get-pet-by-id/:id", upload.single("petImage"), getPetById);

// --- Update Pet Details ---
router.put("/update-pet/:id", upload.single("petImage"), updatePet);

// --- Delete Pet ---
router.delete("/delete-pet/:id", upload.single("petImage"), deletePet);

module.exports = router;
