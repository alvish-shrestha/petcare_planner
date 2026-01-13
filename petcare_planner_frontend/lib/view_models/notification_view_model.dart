import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/notification_item.dart';
import 'package:petcare_planner_frontend/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // --- Grouping Logic for UI ---

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

  List<NotificationItem> get yesterdayNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _notifications
        .where(
          (n) =>
              n.createdAt.year == yesterday.year &&
              n.createdAt.month == yesterday.month &&
              n.createdAt.day == yesterday.day,
        )
        .toList();
  }

  List<NotificationItem> get olderNotifications {
    final startOfYesterday = DateTime.now().subtract(const Duration(days: 1));
    final threshold = DateTime(
      startOfYesterday.year,
      startOfYesterday.month,
      startOfYesterday.day,
    );
    return _notifications
        .where((n) => n.createdAt.isBefore(threshold))
        .toList();
  }

  // --- Actions ---

  /// Loads the history from SharedPreferences
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
        // Ensure newest are always at the top
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        _notifications = [];
      }
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> scheduleTaskReminder({
    required String title,
    required String body,
    required String type,
    required DateTime scheduledTime,
  }) async {
    final idInt = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _notificationService.scheduleNotification(
      id: idInt,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      type: type,
    );

    await loadNotifications();
  }

  /// Use this for manual/instant notifications (like a 'Success' alert)
  Future<void> addInstantNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final idInt = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // 1. Show the system popup
    await _notificationService.showNotification(
      id: idInt,
      title: title,
      body: body,
    );

    // 2. Add to UI History manually (since showNotification doesn't save to list)
    final newItem = NotificationItem(
      id: idInt.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: type,
    );

    _notifications.insert(0, newItem);
    await _saveToPrefs();
    notifyListeners();
  }

  /// Mark a specific notification as read
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    for (var n in _notifications) {
      n.isRead = true;
    }
    await _saveToPrefs();
    notifyListeners();
  }

  /// Deletes notification from UI and system (if scheduled)
  Future<void> deleteNotification(String id) async {
    // 1. Cancel system notification if it was scheduled
    final idInt = int.tryParse(id);
    if (idInt != null) {
      await _notificationService.cancel(idInt);
    }

    // 2. Remove from local list
    _notifications.removeWhere((n) => n.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  /// Completely wipe notification history
  Future<void> clearAll() async {
    _notifications.clear();
    await _notificationService.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('local_notifications');
    notifyListeners();
  }

  // Helper to sync local list to storage
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = NotificationItem.encode(_notifications);
    await prefs.setString('local_notifications', encodedData);
  }
}
