import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  static const String _userKey = 'logged_in_user';

  /// LOGIN
  Future<User> login(String email, String password) async {
    final response = await _authService.login(email, password);

    final user = User.fromJson(response);

    await _saveUser(user);

    return user;
  }

  /// REGISTER
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _authService.register(
      name,
      email,
      password,
      confirmPassword,
    );

    final user = User.fromJson(response);
    await _saveUser(user);

    return user;
  }

  /// SAVE USER LOCALLY
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// GET SAVED USER (AUTO LOGIN / OFFLINE)
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString == null) return null;

    return User.fromJson(jsonDecode(userString));
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// CHECK LOGIN STATUS
  Future<bool> isLoggedIn() async {
    final user = await getSavedUser();
    return user != null;
  }
}
