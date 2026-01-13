import 'dart:convert';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String type; // 'feeding', 'walking', 'grooming', 'medical'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    this.isRead = false,
  });

  // Convert to JSON (For saving to SharedPrefs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'isRead': isRead,
    };
  }

  // Create from JSON (For loading from SharedPrefs)
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
      type: json['type'],
      isRead: json['isRead'],
    );
  }

  // Helper to encode list to string
  static String encode(List<NotificationItem> notifications) => json.encode(
    notifications.map<Map<String, dynamic>>((n) => n.toJson()).toList(),
  );

  // Helper to decode string to list
  static List<NotificationItem> decode(String notifications) =>
      (json.decode(notifications) as List<dynamic>)
          .map<NotificationItem>((item) => NotificationItem.fromJson(item))
          .toList();
}
