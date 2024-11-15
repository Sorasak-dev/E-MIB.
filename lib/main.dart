import 'package:emib_hospital/pages/recommend_pages.dart';
import 'package:emib_hospital/user/calender.dart';
import 'package:emib_hospital/user/faverite.dart';
import 'package:emib_hospital/user/homepage.dart';
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthCheck(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF4C7766),
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String? userId;

  const MainScreen({Key? key, this.userId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentBottomIndex = 2;
  DateTime? _selectedDate;
  int? _sys;
  int? _dia;
  int? _pul;
  String? _status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentBottomIndex,
        children: [
          MyHomePage(),
          Faverite(),
          BloodPressureLogger(
            onSave: (selectedDate, sys, dia, pul, status) {
              setState(() {
                _currentBottomIndex = 3;
                _selectedDate = selectedDate;
                _sys = sys;
                _dia = dia;
                _pul = pul;
                _status = status;
              });
            },
          ),
          RecommendPages(
            selectedDate: _selectedDate,
            sys: _sys,
            dia: _dia,
            pul: _pul,
            status: _status,
          ),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 60,
            child: BottomNavigationBar(
              currentIndex: _currentBottomIndex,
              onTap: (index) {
                setState(() {
                  _currentBottomIndex = index;
                });
              },
              backgroundColor: const Color(0xFFcacafe),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
            ),
          ),
          _buildFloatingIcon(context, _currentBottomIndex),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(BuildContext context, int index) {
    double leftPosition;
    IconData icon;

    switch (index) {
      case 0:
        leftPosition = MediaQuery.of(context).size.width * 0.1;
        icon = Icons.article;
        break;
      case 1:
        leftPosition = MediaQuery.of(context).size.width * 0.3;
        icon = Icons.favorite;
        break;
      case 2:
        leftPosition = MediaQuery.of(context).size.width * 0.5;
        icon = Icons.calendar_today;
        break;
      case 3:
        leftPosition = MediaQuery.of(context).size.width * 0.7;
        icon = Icons.receipt;
        break;
      case 4:
        leftPosition = MediaQuery.of(context).size.width * 0.9;
        icon = Icons.person;
        break;
      default:
        leftPosition = MediaQuery.of(context).size.width * 0.5;
        icon = Icons.calendar_today;
        break;
    }

    return Positioned(
      top: -20,
      left: leftPosition - 30,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFc4e9fc),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
