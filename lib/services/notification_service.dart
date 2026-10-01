import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

  static bool _initialized = false;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // Platform-specific notification configuration will be added
    // when we connect the notification package.
    _initialized = true;
  }

  // ============================================================
  // STATUS
  // ============================================================

  static bool get isInitialized => _initialized;

  // ============================================================
  // REQUEST PERMISSION
  // ============================================================

  static Future<bool> requestPermission() async {
    if (!_initialized) {
      await initialize();
    }

    // Placeholder until the native notification package is added.
    return true;
  }

  // ============================================================
  // DAILY REMINDER
  // ============================================================

  static Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    debugPrint(
      'Daily notification scheduled: '
      '$title at $hour:${minute.toString().padLeft(2, '0')}',
    );
  }

  // ============================================================
  // WATER REMINDER
  // ============================================================

  static Future<void> scheduleWaterReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    debugPrint(
      'Water reminder scheduled: '
      '$title at $hour:${minute.toString().padLeft(2, '0')}',
    );
  }

  // ============================================================
  // WORKOUT REMINDER
  // ============================================================

  static Future<void> scheduleWorkoutReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    debugPrint(
      'Workout reminder scheduled: '
      '$title at $hour:${minute.toString().padLeft(2, '0')}',
    );
  }

  // ============================================================
  // SHOW IMMEDIATE NOTIFICATION
  // ============================================================

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    debugPrint(
      'Notification: $title - $body',
    );
  }

  // ============================================================
  // CANCEL ONE
  // ============================================================

  static Future<void> cancelNotification(int id) async {
    debugPrint(
      'Notification cancelled: $id',
    );
  }

  // ============================================================
  // CANCEL ALL
  // ============================================================

  static Future<void> cancelAllNotifications() async {
    debugPrint(
      'All notifications cancelled.',
    );
  }
}