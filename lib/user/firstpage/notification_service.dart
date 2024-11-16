import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final List<Map<String, String>> _notifications = [];

  static List<Map<String, String>> get notifications =>
      List.unmodifiable(_notifications);

  static void addNotification(RemoteMessage message) {
    final timestamp = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    _notifications.add({
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "timestamp": timestamp,
    });
  }

  static void removeNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
    }
  }

  static void clearAllNotifications() {
    _notifications.clear();
  }
}
