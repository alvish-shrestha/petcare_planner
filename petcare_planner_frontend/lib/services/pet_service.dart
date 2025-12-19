import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:petcare_planner_frontend/utils/api_config.dart';

class PetService {
  /// --- ADD PET (with image) ---
  Future<Map<String, dynamic>> addPet({
    required String petType,
    required String petName,
    required String breed,
    required int age,
    required String gender,
    File? petImage,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/pet/add-pet');

    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'petType': petType,
      'petName': petName,
      'breed': breed,
      'age': age.toString(),
      'gender': gender,
    });

    if (petImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('petImage', petImage.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final decoded = jsonDecode(responseBody);

    if (response.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to add pet');
    }
  }

  /// --- GET ALL PETS ---
  Future<Map<String, dynamic>> getAllPets() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/pet/get-all-pet'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to fetch pets',
      );
    }
  }

  /// --- GET PET BY ID ---
  Future<Map<String, dynamic>> getPetById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/pet/get-pet-by-id/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Pet not found');
    }
  }

  /// --- UPDATE PET ---
  Future<Map<String, dynamic>> updatePet({
    required String id,
    String? petType,
    String? petName,
    String? breed,
    int? age,
    String? gender,
    File? petImage,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/pet/update-pet/$id');

    final request = http.MultipartRequest('PUT', uri);

    if (petType != null) request.fields['petType'] = petType;
    if (petName != null) request.fields['petName'] = petName;
    if (breed != null) request.fields['breed'] = breed;
    if (age != null) request.fields['age'] = age.toString();
    if (gender != null) request.fields['gender'] = gender;

    if (petImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('petImage', petImage.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final decoded = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to update pet');
    }
  }

  /// --- DELETE PET ---
  Future<Map<String, dynamic>> deletePet(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/pet/delete-pet/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to delete pet',
      );
    }
  }
}
