import 'package:emib_hospital/pages/news_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:emib_hospital/user/firstpage/login.dart';
import 'package:emib_hospital/user/firstpage/signup.dart';
import 'package:emib_hospital/pages/news_pages.dart';
import 'package:emib_hospital/tab/drink_tab.dart';
import 'package:emib_hospital/tab/exercise_tab.dart';
import 'package:emib_hospital/tab/food_tab.dart';
import 'package:emib_hospital/tab/fruit_tab.dart';
import 'package:emib_hospital/tab/vegetable_tab.dart';
import 'package:emib_hospital/util/my_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const WelcomeScreen(), // Main screen
      routes: {
        '/login': (context) => const LoginPage(),
        '/Signup': (context) => const SignUpPage(),
        '/New': (context) => const NewsPages(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigating to the login screen
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Go to Login'),
            ),
            SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Navigating to the New screen
                Navigator.pushNamed(context, '/New');
              },
              child: const Text('Go to News Pages'),
            ),
          ],
        ),
      ),
    );
  }
}
