import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petcare_planner_frontend/utils/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardService {
  Future<String?> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> fetchRewardSummary() async {
    final token = await _getTokenFromStorage();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/rewards/summary'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reward summary');
    }
  }

  Future<Map<String, dynamic>> fetchUserBadges() async {
    final token = await _getTokenFromStorage();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/rewards/badges'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user badges');
    }
  }

  Future<Map<String, dynamic>> fetchMilestones() async {
    final token = await _getTokenFromStorage();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/rewards/milestones'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load milestones');
    }
  }
}
