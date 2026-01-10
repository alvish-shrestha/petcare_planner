import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class TaskService {
  /// --- CREATE TASK ---
  Future<Map<String, dynamic>> createTask({
    required String taskTitle,
    required String petId,
    required String taskType,
    required String date,
    required String time,
    String repeat = 'None',
    String? notes,
    bool reminder = true,
  }) async {
    final token = await _getTokenFromStorage();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/task/create-task'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'taskTitle': taskTitle,
        'petId': petId,
        'taskType': taskType,
        'date': date,
        'time': time,
        'repeat': repeat,
        'notes': notes,
        'reminder': reminder,
      }),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to create task');
    }
  }

  /// --- GET ALL TASKS ---
  Future<Map<String, dynamic>> getAllTasks({String? petId}) async {
    final token = await _getTokenFromStorage();

    final uri = petId != null
        ? Uri.parse('${ApiConfig.baseUrl}/api/task/get-all-task?petId=$petId')
        : Uri.parse('${ApiConfig.baseUrl}/api/task/get-all-task');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to fetch tasks',
      );
    }
  }

  /// --- GET TASK BY ID ---
  Future<Map<String, dynamic>> getTaskById(String id) async {
    final token = await _getTokenFromStorage();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/task/get-task-by-id/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Task not found');
    }
  }

  /// --- UPDATE TASK ---
  Future<Map<String, dynamic>> updateTask({
    required String id,
    Map<String, dynamic>? updateData,
  }) async {
    final token = await _getTokenFromStorage();

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/task/update-task/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updateData ?? {}),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to update task');
    }
  }

  /// --- DELETE TASK ---
  Future<Map<String, dynamic>> deleteTask(String id) async {
    final token = await _getTokenFromStorage();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/task/delete-task/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to delete task',
      );
    }
  }

  /// --- GET TOKEN ---
  Future<String?> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
