import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:emib_hospital/user/firstpage/notification_service.dart';
import 'package:emib_hospital/user/firstpage/auth_check.dart';
import 'package:emib_hospital/user/homepage.dart';
import 'package:emib_hospital/user/faverite.dart';
import 'package:emib_hospital/pages/recommend_pages.dart';
import 'package:emib_hospital/user/calender.dart';
import 'package:emib_hospital/user/firstpage/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Setup notifications
  await setupFlutterNotifications();

  // Get FCM token for debugging
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

  final PageController _pageController = PageController(initialPage: 2);

  @override
  void initState() {
    super.initState();

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message Received: ${message.notification?.title}");
      if (message.notification != null) {
        _showNotification(
            message); // Show notification using flutter_local_notifications
      }
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
          MyHomePage(),
          Faverite(),
          BloodPressureLogger(
            onSave: (selectedDate, sys, dia, pul, status) {
              setState(() {
                _selectedDate = selectedDate;
                _sys = sys;
                _dia = dia;
                _pul = pul;
                _status = status;
                _pageController.jumpToPage(3);
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
                  _pageController.jumpToPage(index);
                });
              },
              backgroundColor: const Color(0xFFcacafe),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Articles',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
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

  Widget _buildFloatingIcon(BuildContext context, int index) {
    final double leftPosition =
        (MediaQuery.of(context).size.width / 5) * index + 10;
    final List<IconData> icons = [
      Icons.article,
      Icons.favorite,
      Icons.calendar_today,
      Icons.receipt,
      Icons.person,
    ];

    return Positioned(
      top: -20,
      left: leftPosition,
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
          icons[index],
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }

  void _showNotification(RemoteMessage message) async {
    await showNotification(
        message); // Call function from notification_service.dart
  }
}
