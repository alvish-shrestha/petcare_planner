import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petcare_planner_frontend/utils/api_config.dart';

class AuthService {
  /// --- Register ---
  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Registration failed',
      );
    }
  }

  /// --- Login ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
    }
  }
}
