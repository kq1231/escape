import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:escape/models/timings_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: '');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          linux: initializationSettingsLinux,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // Request permissions for Android 13+
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    // Handle notification tap - could navigate to prayer screen
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }

  /// Schedule prayer notifications for today
  Future<void> schedulePrayerNotifications(Timings timings) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Cancel existing prayer notifications
    await cancelPrayerNotifications();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Prayer times and their corresponding notification IDs
    final prayerTimes = {
      'Fajr': _parseTime(timings.fajr, today),
      'Dhuhr': _parseTime(timings.dhuhr, today),
      'Asr': _parseTime(timings.asr, today),
      'Maghrib': _parseTime(timings.maghrib, today),
      'Isha': _parseTime(timings.isha, today),
    };

    // Schedule notifications for each prayer
    for (final entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;

      // Only schedule if the prayer time is in the future
      if (prayerTime.isAfter(now)) {
        await _schedulePrayerNotification(
          id: _getPrayerNotificationId(prayerName),
          prayerName: prayerName,
          scheduledTime: prayerTime,
        );

        // Schedule a reminder 10 minutes before
        final reminderTime = prayerTime.subtract(const Duration(minutes: 10));
        if (reminderTime.isAfter(now)) {
          await _schedulePrayerReminder(
            id: _getPrayerReminderNotificationId(prayerName),
            prayerName: prayerName,
            scheduledTime: reminderTime,
          );
        }
      }
    }

    debugPrint('Prayer notifications scheduled for today');
  }

  /// Schedule a single prayer notification
  Future<void> _schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'prayer_notifications',
          'Prayer Notifications',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          sound: 'adhan.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '🕌 $prayerName Prayer Time',
      'It\'s time for $prayerName prayer. May Allah accept your prayers.',
      _convertToTZDateTime(scheduledTime),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'prayer_$prayerName',
    );
  }

  /// Schedule a prayer reminder notification
  Future<void> _schedulePrayerReminder({
    required int id,
    required String prayerName,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'prayer_reminders',
          'Prayer Reminders',
          channelDescription: 'Reminders for upcoming prayer times',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '⏰ $prayerName Prayer Reminder',
      '$prayerName prayer is in 10 minutes. Prepare for prayer.',
      _convertToTZDateTime(scheduledTime),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'reminder_$prayerName',
    );
  }

  /// Cancel all prayer notifications
  Future<void> cancelPrayerNotifications() async {
    final prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (final prayerName in prayerNames) {
      await _flutterLocalNotificationsPlugin.cancel(
        _getPrayerNotificationId(prayerName),
      );
      await _flutterLocalNotificationsPlugin.cancel(
        _getPrayerReminderNotificationId(prayerName),
      );
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get notification ID for prayer
  int _getPrayerNotificationId(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return 1001;
      case 'Dhuhr':
        return 1002;
      case 'Asr':
        return 1003;
      case 'Maghrib':
        return 1004;
      case 'Isha':
        return 1005;
      default:
        return 1000;
    }
  }

  /// Get reminder notification ID for prayer
  int _getPrayerReminderNotificationId(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return 2001;
      case 'Dhuhr':
        return 2002;
      case 'Asr':
        return 2003;
      case 'Maghrib':
        return 2004;
      case 'Isha':
        return 2005;
      default:
        return 2000;
    }
  }

  /// Parse time string to DateTime
  DateTime _parseTime(String timeString, DateTime date) {
    try {
      // Remove any extra spaces and split by ':'
      final cleanTime = timeString.trim();
      final parts = cleanTime.split(':');

      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        return DateTime(date.year, date.month, date.day, hour, minute);
      }
    } catch (e) {
      debugPrint('Error parsing time: $timeString - $e');
    }

    // Return current time as fallback
    return DateTime.now();
  }

  /// Convert DateTime to TZDateTime (using system timezone)
  dynamic _convertToTZDateTime(DateTime dateTime) {
    // For now, we'll use the system timezone
    // In a production app, you might want to use the timezone package
    return dateTime;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final settings = await iOSImplementation?.checkPermissions();
      return settings?.isEnabled ?? false;
    }

    return false;
  }

  /// Show immediate notification (for testing)
  Future<void> showTestNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'test_notifications',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      9999,
      'Test Notification',
      'This is a test notification from Escape app',
      platformChannelSpecifics,
      payload: 'test',
    );
  }
}
