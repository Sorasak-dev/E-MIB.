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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  int _currentBottomIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  DateTime? _selectedDate;
  int? _sys;
  int? _dia;
  int? _pul;
  String? _status;

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
          FavoritePage(
            favorites: [], // ใส่รายการ Favorite ที่ต้องการ (สามารถใช้ List ว่างได้)
            onFavoriteToggle: (item) {
              // ฟังก์ชันสำหรับเปิด/ปิดสถานะ Favorite
              print('Toggled favorite for $item');
            },
            onDelete: (item) {
              // ฟังก์ชันสำหรับลบรายการ
              print('Deleted favorite item: $item');
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
              onTap: _onBottomNavigationTapped, // ใช้ฟังก์ชันนี้
              backgroundColor: Color(0xFFcacafe),
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

  // ฟังก์ชันจัดการการเปลี่ยนหน้า
  void _onBottomNavigationTapped(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    // ใช้ Future.microtask เพื่อเลี่ยงข้อผิดพลาด jumpToPage
    Future.microtask(() => _pageController.jumpToPage(index));
  }

  // ฟังก์ชันสำหรับสร้างไอคอนที่นูนขึ้นเมื่อถูกเลือก
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
      top: -20, // ยกไอคอนขึ้น
      left: leftPosition - 30,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFc4e9fc), // สีพื้นหลังของไอคอนที่ถูกเลือก
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 3), // ตำแหน่งเงา
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 28, // ขนาดของไอคอนที่นูนขึ้น
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
