import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Notification Channel สำหรับ Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // Channel ID
  'High Importance Notifications', // ชื่อ Channel
  description: 'This channel is used for important notifications.', // คำอธิบาย
  importance: Importance.high, // ความสำคัญของการแจ้งเตือน
);

/// ตั้งค่า Flutter Local Notifications
Future<void> setupFlutterNotifications() async {
  // ตั้งค่าเริ่มต้นสำหรับ Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // รวมการตั้งค่าทุกแพลตฟอร์ม
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // กำหนดการทำงานเมื่อผู้ใช้คลิกการแจ้งเตือน
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        print("Notification clicked with payload: ${response.payload}");
      }
    },
  );

  // สร้าง Notification Channel สำหรับ Android 8.0+
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

/// แสดงการแจ้งเตือนใน Local Notifications
Future<void> showNotification(RemoteMessage message) async {
  // ตั้งค่าการแสดงผลสำหรับ Android
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'high_importance_channel', // ต้องตรงกับ Channel ที่สร้าง
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
  );

  // รวมการตั้งค่าทุกแพลตฟอร์ม
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  // แสดงการแจ้งเตือน
  await flutterLocalNotificationsPlugin.show(
    message.hashCode, // ใช้ hashCode เพื่อให้ ID ของการแจ้งเตือนไม่ซ้ำ
    message.notification?.title ?? 'No title', // หัวข้อ
    message.notification?.body ?? 'No body', // เนื้อหา
    notificationDetails,
    payload: message.data['payload'] ?? '', // ข้อมูลเพิ่มเติม
  );
}

class NotificationService {
  // เก็บรายการการแจ้งเตือน
  static final List<Map<String, String>> _notifications = [];

  // ดึงรายการแจ้งเตือน
  static List<Map<String, String>> getNotifications() {
    return _notifications;
  }

  // เพิ่มการแจ้งเตือนใหม่
  static void addNotification(Map<String, String> notification) {
    _notifications.add(notification);
  }
}
