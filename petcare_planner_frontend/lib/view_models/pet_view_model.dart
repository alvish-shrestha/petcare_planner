import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/pet_repository.dart';

class PetViewModel extends ChangeNotifier {
  final PetRepository _repository;

  PetViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  List<Pet> pets = [];
  Pet? selectedPet;

  static const String _selectedPetKey = 'selected_pet_id';

  File? petImage;

  String? petType;
  String? gender;

  final ImagePicker _picker = ImagePicker();

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

  Future<bool> addPet({
    required String petName,
    required String breed,
    required int age,
  }) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _repository.addPet(
        petType: petType!,
        petName: petName,
        breed: breed,
        age: age,
        gender: gender!,
        petImage: petImage,
      );

      await fetchPets();

      _reset();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _reset() {
    petType = null;
    gender = null;
    petImage = null;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Future<void> fetchPets() async {
  //   _setLoading(true);
  //   errorMessage = null;

  //   try {
  //     final response = await _repository.getAllPets();
  //     if (response['success'] == true) {
  //       pets = (response['pets'] as List).map((e) => Pet.fromJson(e)).toList();
  //     } else {
  //       errorMessage = response['message'] ?? 'Failed to load pets';
  //     }
  //   } catch (e) {
  //     errorMessage = e.toString();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> fetchPets() async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await _repository.getAllPets();

      if (response['success'] == true) {
        pets = (response['pets'] as List).map((e) => Pet.fromJson(e)).toList();

        print("Fetched pets: ${pets.length}");

        await _restoreSelectedPet();
      } else {
        errorMessage = response['message'] ?? 'Failed to load pets';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectPet(Pet pet) async {
    selectedPet = pet;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedPetKey, pet.id);
  }

  Future<void> _restoreSelectedPet() async {
    if (pets.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final savedPetId = prefs.getString(_selectedPetKey);

    if (savedPetId != null) {
      selectedPet = pets.firstWhere(
        (pet) => pet.id == savedPetId,
        orElse: () => pets.first,
      );
    } else {
      selectedPet = pets.first;
    }
    notifyListeners();
  }
}
