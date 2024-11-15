import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

/// Background Message Handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message Received: ${message.notification?.title}");
  await showNotification(message);
}
