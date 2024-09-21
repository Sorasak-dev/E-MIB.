import 'package:flutter/material.dart';
import 'home_page.dart';        // นำเข้าหน้าหลัก
import 'favorite_page.dart';    // นำเข้าหน้าที่ชื่นชอบ
import 'calendar_page.dart';    // นำเข้าหน้าปฏิทิน
import 'receipt_page.dart';     // นำเข้าหน้ารายงาน
import 'profile_page.dart';     // นำเข้าหน้าบัญชีผู้ใช้
import 'notification_page.dart';// นำเข้าหน้า NotificationPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF4C7766),
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentBottomIndex = 2; // เริ่มต้นที่ CalendarPage
  String _selectedDrawerButton = 'Day'; // สถานะของปุ่มที่ถูกเลือกใน Drawer

  // รายการหน้าที่จะสลับไปมา
  final List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    CalendarPage(),
    ReceiptPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () async {
              // เปิดหน้า NotificationPage และรอรับค่า index กลับมา
              final selectedIndex = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
              // ตรวจสอบว่ามีการส่งค่ากลับมาจริงหรือไม่
              if (selectedIndex != null && selectedIndex is int) {
                setState(() {
                  _currentBottomIndex = selectedIndex; // อัปเดตค่าเมนูที่ถูกเลือก
                });
              }
            },
          ),
        ],
      ),
      drawer:  _buildDrawer() ,
      body: IndexedStack(
        index: _currentBottomIndex,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // ป้องกันไม่ให้ไอคอนถูกตัดขาด
        children: [
          Container(
            height: 60, // ปรับความสูงของ BottomNavigationBar
            child: BottomNavigationBar(
              currentIndex: _currentBottomIndex,
              onTap: (index) {
                setState(() {
                  _currentBottomIndex = index;
                });
              },
              backgroundColor: Color(0xFFcacafe),
              type: BottomNavigationBarType.fixed,
              items: [
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
              selectedItemColor: Colors.black, // สีของไอคอนที่ถูกเลือก
              unselectedItemColor: Colors.black, // สีของไอคอนที่ไม่ได้เลือก
            ),
          ),
          _buildFloatingIcon(context, _currentBottomIndex), // เรียกฟังก์ชันที่ยกไอคอนขึ้น
        ],
      ),
    );
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

  // ฟังก์ชันสร้าง Drawer และตรวจสอบ _currentBottomIndex
  // ปรับให้ Drawer และปุ่มไปอยู่ด้านบนและลดขนาดลง
  Widget _buildDrawer() {
    if (_currentBottomIndex == 2) {
      return Drawer(
        backgroundColor: Color(0xFFD1E8F5),
        width: 240,
        child: Stack(
          children: [
            Container(
              width: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80), // เพิ่มช่องว่างด้านบนเพื่อเว้นที่สำหรับไอคอน
                  Container(
                    width: 120, // กำหนดความกว้างของกล่องปุ่ม
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue ,width: 2), // ขอบสีฟ้า
                      borderRadius: BorderRadius.circular(10), // ขอบโค้งมนเล็กน้อย
                    ),
                    child: Column(
                      children: [
                        _buildDrawerButton('Day', _selectedDrawerButton == 'Day' ? Color(0xFFfffdd7) : Colors.white, () {
                          setState(() {
                            _selectedDrawerButton = 'Day';
                          });
                        }),
                        _buildDrawerButton('Month', _selectedDrawerButton == 'Month' ? Color(0xFFfffdd7) : Colors.white, () {
                          setState(() {
                            _selectedDrawerButton = 'Month';
                          });
                        }),
                        _buildDrawerButton('Year', _selectedDrawerButton == 'Year' ? Color(0xFFfffdd7) : Colors.white, () {
                          setState(() {
                            _selectedDrawerButton = 'Year';
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20, // ระยะจากขอบบน
              right: 20, // ระยะจากขอบขวา
              child:Transform.rotate(
                  angle: 90 * 3.14159 / 180, // หมุน 90 องศา
                  child: Icon(
                    Icons.menu, // ใช้ไอคอนของ Drawer (ไอคอน 3 ขีด)
                    size: 25,   // กำหนดขนาดของไอคอน
                    color: Colors.black, // กำหนดสีของไอคอน
                  ),
            ),
            ),
          ],
        ),
      );
    } else {
      return Drawer();
    }
  }

  // ปรับขนาดปุ่มใน Drawer ให้เล็กลง
  Widget _buildDrawerButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.blue, width: 1),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity, 50), // ลดความสูงของปุ่ม
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16, // ลดขนาดฟอนต์
            color: Colors.black,
          ),
        ),
      ),
    );
  }

}
