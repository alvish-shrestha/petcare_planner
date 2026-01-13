import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  // Default values
  bool _pushNotifications = true;
  bool _taskReminders = true;
  bool _soundEnabled = true;

  // Getters
  bool get pushNotifications => _pushNotifications;
  bool get taskReminders => _taskReminders;
  bool get soundEnabled => _soundEnabled;

  SettingsViewModel() {
    loadSettings();
  }

  // Load from Storage
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _pushNotifications = prefs.getBool('push_notifications') ?? true;
    _taskReminders = prefs.getBool('task_reminders') ?? true;
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    notifyListeners();
  }

  // --- Toggles ---

  Future<void> togglePushNotifications(bool value) async {
    _pushNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', value);
  }

  Future<void> toggleTaskReminders(bool value) async {
    _taskReminders = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('task_reminders', value);
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', value);
  }
}