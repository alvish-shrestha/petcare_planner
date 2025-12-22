import 'dart:io';
import '../services/pet_service.dart';

class PetRepository {
  final PetService _petService;

  PetRepository(this._petService);

  /// ---------------- ADD PET ----------------
  Future<Map<String, dynamic>> addPet({
    required String petType,
    required String petName,
    required String breed,
    required int age,
    required String gender,
    File? petImage,
  }) {
    return _petService.addPet(
      petType: petType,
      petName: petName,
      breed: breed,
      age: age,
      gender: gender,
      petImage: petImage,
    );
  }

  /// ---------------- GET ALL PETS ----------------
  Future<Map<String, dynamic>> getAllPets() {
    return _petService.getAllPets();
  }

  /// ---------------- GET PET BY ID ----------------
  Future<Map<String, dynamic>> getPetById(String id) {
    return _petService.getPetById(id);
  }

  /// ---------------- UPDATE PET ----------------
  Future<Map<String, dynamic>> updatePet({
    required String id,
    String? petType,
    String? petName,
    String? breed,
    int? age,
    String? gender,
    File? petImage,
  }) {
    return _petService.updatePet(
      id: id,
      petType: petType,
      petName: petName,
      breed: breed,
      age: age,
      gender: gender,
      petImage: petImage,
    );
  }

  /// ---------------- DELETE PET ----------------
  Future<Map<String, dynamic>> deletePet(String id) {
    return _petService.deletePet(id);
  }
}
