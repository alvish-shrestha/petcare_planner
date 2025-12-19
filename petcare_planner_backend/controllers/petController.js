const Pet = require("../models/Pet");

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
