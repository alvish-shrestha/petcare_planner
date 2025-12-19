import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import '../repositories/pet_repository.dart';

class PetViewModel extends ChangeNotifier {
  final PetRepository _repository;

  PetViewModel(this._repository);

  // ---------------- STATE ----------------
  bool isLoading = false;
  String? errorMessage;

  List<Pet> pets = [];
  Pet? selectedPet;

  File? petImage;

  // ---------------- CONTROLLERS ----------------
  final petNameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();

  String? petType;
  String? gender;

  final ImagePicker _picker = ImagePicker();

  // ---------------- IMAGE PICKER ----------------
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      petImage = File(image.path);
      notifyListeners();
    }
  }

  void setPetType(String type) {
    petType = type;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  // ---------------- ADD PET ----------------
  Future<bool> addPet() async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.addPet(
        petType: petType!,
        petName: petNameController.text.trim(),
        breed: breedController.text.trim(),
        age: int.parse(ageController.text),
        gender: gender!,
        petImage: petImage,
      );

      _resetForm();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- FETCH ALL PETS ----------------
  Future<void> fetchAllPets() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.getAllPets();
      final List data = response['pets'];

      pets = data.map((e) => Pet.fromJson(e)).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- FETCH PET BY ID ----------------
  Future<void> fetchPetById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _repository.getPetById(id);
      selectedPet = Pet.fromJson(response['pet']);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- UPDATE PET ----------------
  Future<bool> updatePet(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.updatePet(
        id: id,
        petType: petType,
        petName: petNameController.text.trim(),
        breed: breedController.text.trim(),
        age: int.parse(ageController.text),
        gender: gender,
        petImage: petImage,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- DELETE PET ----------------
  Future<bool> deletePet(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deletePet(id);
      pets.removeWhere((pet) => pet.id == id);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- HELPERS ----------------
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    errorMessage = null;
  }

  void _resetForm() {
    petNameController.clear();
    breedController.clear();
    ageController.clear();
    petType = null;
    gender = null;
    petImage = null;
  }

  @override
  void dispose() {
    petNameController.dispose();
    breedController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
