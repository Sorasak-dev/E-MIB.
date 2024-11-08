import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:emib_hospital/user/firstpage/notification_service.dart';
import 'package:emib_hospital/user/firstpage/auth_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:emib_hospital/user/firstpage/login.dart';
import 'package:emib_hospital/user/firstpage/signup.dart';
import 'package:emib_hospital/pages/news_pages.dart';
import 'package:emib_hospital/user/firstpage/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // เรียกใช้ firebaseMessagingBackgroundHandler จาก notification_service.dart
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await setupFlutterNotifications();

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthCheck(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/Signup': (context) => const SignUpPage(),
        '/New': (context) => const NewsPages(),
        '/Settings': (context) => const SettingsPage(),
      },
    );
  }
}
