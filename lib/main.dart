import 'package:emib_hospital/user/History.dart';
import 'package:emib_hospital/user/favorite_page.dart';
import 'package:emib_hospital/user/homepage.dart';
import 'package:emib_hospital/user/firstpage/firebase_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:emib_hospital/user/firstpage/notification_service.dart';
import 'package:emib_hospital/user/firstpage/auth_check.dart';
import 'package:emib_hospital/user/homepage.dart';
import 'package:emib_hospital/user/recommend_pages.dart';
import 'package:emib_hospital/user/calender.dart';
import 'package:emib_hospital/user/firstpage/setting.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load saved notifications
  await NotificationService.loadNotificationsFromLocalStorage();
  // Background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Setup notifications
  await setupFlutterNotifications();

  // Get FCM token for debugging
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF4C7766),
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
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
  int _currentBottomIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> _records = [];

  DateTime? _selectedDate;
  int? _sys;
  int? _dia;
  int? _pul;
  String? _status;

  @override
  void initState() {
    super.initState();

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message Received: ${message.notification?.title}");

      // Add notification to NotificationService
      NotificationService.addNotification(message);

      // Show notification locally
      _showNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
        children: [
          MyHomePage(
            status: _status, // ส่งค่าสถานะไปยัง MyHomePage
            date: _selectedDate, // ส่งวันที่ไปยัง MyHomePage
          ),
          HistoryPage(
            records: _records, // ส่งประวัติที่บันทึกไปยัง HistoryPage
            onDelete: (index) {
              setState(() {
                _records.removeAt(index); // ลบข้อมูลใน List
              });
            },
          ),
          BloodPressureLogger(
            onSave: (selectedDate, sys, dia, pul, status) {
              setState(() {
                _selectedDate = selectedDate;
                _sys = sys;
                _dia = dia;
                _pul = pul;
                _status = status;
                _pageController.jumpToPage(3);
                // เพิ่มข้อมูลบันทึกในประวัติ
                _records.add({
                  'date': selectedDate,
                  'sys': sys,
                  'dia': dia,
                  'pul': pul,
                  'status': status,
                });
              });
            },
          ),
          RecommendPages(
            selectedDate: _selectedDate,
            sys: _sys,
            dia: _dia,
            pul: _pul,
            status: _status,
            onClear: () {
              setState(() {
                _selectedDate = null;
                _sys = null;
                _dia = null;
                _pul = null;
                _status = null;
              });
            },
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
              onTap: _onBottomNavigationTapped,
              backgroundColor: Color(0xFFcacafe),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Articles',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: 'Recommendations',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Settings',
                ),
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
            ),
          ),
          _buildFloatingIcon(context, _currentBottomIndex),
        ],
      ),
    );
  }

  void _onBottomNavigationTapped(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    Future.microtask(() => _pageController.jumpToPage(index));
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
        icon = Icons.history;
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFc4e9fc),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 3),
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

void _showNotification(RemoteMessage message) async {
  try {
    await showNotification(message);
  } catch (e) {
    print("Error showing notification: $e");
  }
}
