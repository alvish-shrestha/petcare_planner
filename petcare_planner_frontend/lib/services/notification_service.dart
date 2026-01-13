import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    try {
      var timeZoneResult = await FlutterTimezone.getLocalTimezone();

      String timeZoneName;

      if (timeZoneResult is String) {
        timeZoneName = timeZoneResult as String;
      } else {
        timeZoneName = timeZoneResult.toString();

        if (timeZoneName.contains('(')) {
          timeZoneName = timeZoneName.split('(')[1].split(',')[0].trim();
        }
      }

      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("✅ Timezone successfully set to: $timeZoneName");
    } catch (e) {
      debugPrint("Failed to get local timezone: $e");
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // --- Android initialization ---
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // --- iOS / macOS initialization ---
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );
  }

  // --- Permissions ---
  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? result = await androidImplementation
          ?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  // --- User Settings Helper ---
  Future<Map<String, bool>> _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'push': prefs.getBool('push_notifications') ?? true,
      'reminders': prefs.getBool('task_reminders') ?? true,
      'sound': prefs.getBool('sound_enabled') ?? true,
    };
  }

  // --- Instant Notification ---
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final settings = await _getSettings();

    if (settings['push'] == false) return;

    final bool playSound = settings['sound']!;
    final String channelId = playSound
        ? 'pet_care_channel_sound'
        : 'pet_care_channel_silent';

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Pet Care Reminders',
          channelDescription: 'Notifications for pet care tasks',
          importance: Importance.max,
          priority: Priority.high,
          playSound: playSound,
        ),
        iOS: DarwinNotificationDetails(presentSound: playSound),
      ),
      payload: payload,
    );
  }

  // --- Scheduled Notification ---
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final settings = await _getSettings();

    if (settings['push'] == false) {
      debugPrint("Skipping schedule: Push notifications disabled");
      return;
    }

    if (settings['reminders'] == false) {
      debugPrint("Skipping schedule: Task reminders disabled");
      return;
    }

    final bool playSound = settings['sound']!;
    final String channelId = playSound
        ? 'pet_care_channel_sound'
        : 'pet_care_channel_silent';

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            'Pet Care Reminders',
            importance: Importance.max,
            priority: Priority.high,
            playSound: playSound,
          ),
          iOS: DarwinNotificationDetails(presentSound: playSound),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      debugPrint("Notification scheduled for $scheduledTime");
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  // --- Cancel Notifications ---
  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
