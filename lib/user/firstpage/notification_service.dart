import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService {
  static final List<Map<String, String>> _notifications = [];

  /// ดึงรายการการแจ้งเตือนทั้งหมด
  static List<Map<String, String>> get notifications =>
      List.unmodifiable(_notifications);

  /// เพิ่มการแจ้งเตือนใหม่
  static Future<void> addNotification(RemoteMessage message) async {
    final timestamp = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    final notification = {
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "timestamp": timestamp,
    };

    _notifications.add(notification);
    await _saveNotificationsToLocalStorage();
  }

  /// ลบการแจ้งเตือนตาม index
  static Future<void> removeNotification(int index) async {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      await _saveNotificationsToLocalStorage();
    }
  }

  /// ลบการแจ้งเตือนทั้งหมด
  static Future<void> clearAllNotifications() async {
    _notifications.clear();
    await _saveNotificationsToLocalStorage();
  }

  /// บันทึกการแจ้งเตือนลงใน SharedPreferences
  static Future<void> _saveNotificationsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = jsonEncode(_notifications);
    await prefs.setString('notifications', notificationsJson);
  }

  /// โหลดการแจ้งเตือนจาก SharedPreferences
  static Future<void> loadNotificationsFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString('notifications');
    if (notificationsJson != null) {
      final List<dynamic> decoded = jsonDecode(notificationsJson);
      _notifications.clear();
      _notifications.addAll(decoded.map((e) => Map<String, String>.from(e)));
    }
  }
}
