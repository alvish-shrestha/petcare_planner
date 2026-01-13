import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petcare_planner_frontend/models/notification_item.dart';

class NotificationViewModel extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // --- Grouping Logic for UI ---

  // Returns notifications created today
  List<NotificationItem> get todayNotifications {
    final now = DateTime.now();
    return _notifications
        .where(
          (n) =>
              n.createdAt.year == now.year &&
              n.createdAt.month == now.month &&
              n.createdAt.day == now.day,
        )
        .toList();
  }

  // Returns notifications created yesterday
  List<NotificationItem> get yesterdayNotifications {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return _notifications
        .where(
          (n) =>
              n.createdAt.year == yesterday.year &&
              n.createdAt.month == yesterday.month &&
              n.createdAt.day == yesterday.day,
        )
        .toList();
  }

  // Returns older notifications
  List<NotificationItem> get olderNotifications {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final startOfYesterday = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
    );

    return _notifications
        .where((n) => n.createdAt.isBefore(startOfYesterday))
        .toList();
  }

  // --- Core Actions ---

  // 1. Load Notifications from Local Storage
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsString = prefs.getString(
        'local_notifications',
      );

      if (notificationsString != null) {
        _notifications = NotificationItem.decode(notificationsString);
        // Sort by newest first
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. Add New Notification (Call this when creating a task)
  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: type,
    );

    _notifications.insert(0, newItem); // Add to top of list
    notifyListeners();
    await _saveToPrefs();
  }

  // 3. Mark as Read
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
      await _saveToPrefs();
    }
  }

  // 4. Delete Notification
  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    await _saveToPrefs();
  }

  // Helper to save current list to disk
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = NotificationItem.encode(_notifications);
    await prefs.setString('local_notifications', encodedData);
  }
}
