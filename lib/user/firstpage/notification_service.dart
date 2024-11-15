import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// ตั้งค่า Notification Channel สำหรับ Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // ต้องตรงกับใน `AndroidNotificationDetails`
  'High Importance Notifications', // ชื่อ Channel
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

/// ตั้งค่า Notification (เรียกใน main หรือ setup)
Future<void> setupFlutterNotifications() async {
  // การตั้งค่าเริ่มต้นสำหรับ Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // รวมการตั้งค่าสำหรับทุกแพลตฟอร์ม
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize Flutter Local Notifications
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // สร้าง Notification Channel เฉพาะ Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

/// ฟังก์ชันจัดการข้อความใน Background
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // จำเป็นต้องเรียก Firebase.initializeApp() ถ้าทำงานใน Background
  await setupFlutterNotifications();
  _showNotification(message);
}

/// ฟังก์ชันแสดงการแจ้งเตือน
void _showNotification(RemoteMessage message) async {
  // การตั้งค่า Android Notification
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'high_importance_channel', // ต้องตรงกับ Notification Channel ที่สร้าง
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
  );

  // รวมการตั้งค่าสำหรับทุกแพลตฟอร์ม
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  // แสดงการแจ้งเตือน
  await flutterLocalNotificationsPlugin.show(
    message.hashCode, // ID การแจ้งเตือน (ใช้ hashCode เพื่อไม่ซ้ำ)
    message.notification?.title ?? 'No title', // หัวข้อการแจ้งเตือน
    message.notification?.body ?? 'No body', // เนื้อหาการแจ้งเตือน
    notificationDetails,
  );
}
