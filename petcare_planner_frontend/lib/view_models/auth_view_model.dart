import 'package:flutter/foundation.dart';
import 'package:petcare_planner_frontend/models/user.dart';
import 'package:petcare_planner_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  String? get token => _token;

  AuthViewModel() {
    _loadUserFromPrefsOnInit();
  }

  void _loadUserFromPrefsOnInit() async {
    await loadUserFromPrefs();
  }

  Future<void> saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null && _token != null) {
      prefs.setString('token', _token!);
      prefs.setString('username', _user!.username);
      prefs.setString('email', _user!.email);
      // You can save more user data as needed, possibly as JSON string
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');
    final email = prefs.getString('email');

    if (token != null && username != null && email != null) {
      _token = token;
      _user = User(username: username, email: email, id: '', token: '');
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

      print('Logged in user: ${_user?.username}');
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
