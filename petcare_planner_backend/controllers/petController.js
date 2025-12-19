const Pet = require("../models/Pet");
const fs = require("fs");
const path = require("path");

exports.addPet = async (req, res) => {
  try {
    const { petType, petName, breed, age, gender } = req.body;
    const petImage = req.file ? req.file.path : null;

    // Check for required fields
    if (!petType || !petName || !breed || !age || !gender) {
      return res.status(400).json({
        success: false,
        message: "Please fill all the required fields",
      });
    }

    // Validate petType
    const validTypes = ["Dog", "Cat", "Other"];
    if (!validTypes.includes(petType)) {
      return res.status(400).json({
        success: false,
        message: "Invalid pet type",
      });
    }

    // Validate gender
    const validGenders = ["Male", "Female"];
    if (!validGenders.includes(gender)) {
      return res.status(400).json({
        success: false,
        message: "Invalid gender value",
      });
    }

    // Validate age is a positive number
    const parsedAge = Number(age);
    if (isNaN(parsedAge) || parsedAge < 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid age",
      });
    }

    // Check if pet already exists with same type, name, and breed
    const existingPet = await Pet.findOne({
      petType: petType,
      petName: petName.toLowerCase(),
      breed: breed.toLowerCase(),
      age: parsedAge,
      gender: gender,
    });

    if (existingPet) {
      return res.status(400).json({
        success: false,
        message:
          "Pet with same type, name, breed, age and gender already exists",
      });
    }

    const newPet = new Pet({
      petImage,
      petType: petType,
      petName: petName.toLowerCase(),
      breed: breed.toLowerCase(),
      age: parsedAge,
      gender: gender,
    });

    await newPet.save();

    return res.status(201).json({
      success: true,
      message: "Pet added successfully",
      pet: newPet,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

exports.getAllPets = async (req, res) => {
  try {
    const pets = await Pet.find();
    return res.status(200).json({
      success: true,
      pets,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

exports.getPetById = async (req, res) => {
  try {
    const petId = req.params.id;
    const pet = await Pet.findById(petId);

    if (!pet) {
      return res.status(404).json({
        success: false,
        message: "Pet not found",
      });
    }

    return res.status(200).json({
      success: true,
      pet,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

exports.updatePet = async (req, res) => {
  try {
    const petId = req.params.id;
    const { petType, petName, breed, age, gender } = req.body;
    const petImage = req.file ? req.file.path : null;

    // Normalize fields if provided
    const updateData = {};

    if (petType) {
      const validTypes = ["Dog", "Cat", "Other"];
      if (!validTypes.includes(petType)) {
        return res.status(400).json({
          success: false,
          message: "Invalid pet type",
        });
      }
      updateData.petType = petType;
    }

    if (petName) {
      updateData.petName = petName;
    }

    if (breed) {
      updateData.breed = breed;
    }

    if (age !== undefined) {
      const parsedAge = Number(age);
      if (isNaN(parsedAge) || parsedAge < 0) {
        return res.status(400).json({
          success: false,
          message: "Invalid age",
        });
      }
      updateData.age = parsedAge;
    }

    if (gender) {
      const validGenders = ["Male", "Female"];
      if (!validGenders.includes(gender)) {
        return res.status(400).json({
          success: false,
          message: "Invalid gender value",
        });
      }
      updateData.gender = gender;
    }

    if (petImage) {
      updateData.petImage = petImage;
    }

    // Check if the updated pet already exists to avoid duplicates
    if (
      updateData.petType &&
      updateData.petName &&
      updateData.breed &&
      updateData.age !== undefined &&
      updateData.gender
    ) {
      const existingPet = await Pet.findOne({
        petType: updateData.petType,
        petName: updateData.petName,
        breed: updateData.breed,
        age: updateData.age,
        gender: updateData.gender,
        _id: { $ne: petId },
      });

      if (existingPet) {
        return res.status(400).json({
          success: false,
          message:
            "Another pet with same type, name, breed, age and gender already exists",
        });
      }
    }

    const updatedPet = await Pet.findByIdAndUpdate(petId, updateData, {
      new: true,
    });

    if (!updatedPet) {
      return res.status(404).json({
        success: false,
        message: "Pet not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Pet updated successfully",
      pet: updatedPet,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

exports.deletePet = async (req, res) => {
  try {
    const petId = req.params.id;

    const deletedPet = await Pet.findByIdAndDelete(petId);

    if (!deletedPet) {
      return res.status(404).json({
        success: false,
        message: "Pet not found",
      });
    }

    // Delete the pet image file if it exists
    if (deletedPet.petImage) {
      const imagePath = path.resolve(deletedPet.petImage);
      fs.unlink(imagePath, (err) => {
        if (err) {
          console.error("Failed to delete pet image:", err);
        } else {
          console.log("Pet image deleted:", imagePath);
        }
      });
    }

    return res.status(200).json({
      success: true,
      message: "Pet deleted successfully",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};
