import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:petcare_planner_frontend/models/user.dart';
// import 'package:petcare_planner_frontend/repository/auth_repository.dart';
import 'package:petcare_planner_frontend/services/auth_service.dart';
import 'package:petcare_planner_frontend/utils/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  // late final AuthRepository _authRepository;

  User? _user;
  String? _token;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  String? get token => _token;

  AuthViewModel() {
    // _authRepository = AuthRepository(_authService);
    _loadUserFromPrefsOnInit();
  }

  void _loadUserFromPrefsOnInit() async {
    await loadUserFromPrefs();
  }

  static const _userKey = 'logged_in_user';

  Future<void> saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      _user = User.fromJson(jsonDecode(userString));
      _token = _user!.token;
      notifyListeners();
    }
  }

  Future<void> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        username,
        email,
        password,
        confirmPassword,
      );
      if (result['success'] == true) {
        await login(email, password);
      } else {
        _errorMessage = result['message'] ?? 'Registration failed';
        _user = null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);

      final userJson = Map<String, dynamic>.from(result['data']);
      userJson['token'] = result['token'];
      _user = User.fromJson(userJson);
      _token = result['token'];

      await saveUserToPrefs();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged_in_user');

      _user = null;
      _token = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadProfileImage() async {
    if (_token == null || _user == null) {
      throw Exception('User not logged in');
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        return;
      }

      File imageFile = File(pickedFile.path);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/auth/profile-image'),
      );

      request.headers['Authorization'] = 'Bearer $_token';

      request.files.add(
        await http.MultipartFile.fromPath('profileImage', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        final jsonResp = jsonDecode(respStr);

        if (jsonResp['success'] == true) {
          _user = _user!.copyWith(profileImageUrl: jsonResp['imageUrl']);
          await saveUserToPrefs();
          notifyListeners();
        } else {
          throw Exception(jsonResp['message'] ?? 'Upload failed');
        }
      } else {
        throw Exception(
          'Failed to upload image, status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error picking/uploading image: $e');
    }
  }

  Future<void> updateProfile({
    required String username,
    required String email,
  }) async {
    if (_user == null || _token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.updateProfile(username, email, _token!);

      _user = _user!.copyWith(
        username: result['data']['username'],
        email: result['data']['email'],
      );

      await saveUserToPrefs();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    if (_token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
        token: _token!,
      );

      // await logout();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    if (_token == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/deleteUser'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        await logout();
      } else {
        final jsonResp = jsonDecode(response.body);
        throw Exception(jsonResp['message'] ?? 'Failed to delete account');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
