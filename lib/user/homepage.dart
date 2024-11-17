import 'package:emib_hospital/user/firstpage/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/exercise_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/att_screen.dart'; // นำเข้า AttractionsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHomePage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? status; // รับค่าที่บันทึกมา เช่น "Normal", "Low", "High"
  final DateTime? date; // รับวันที่ที่บันทึก

  const MyHomePage({Key? key, this.status, this.date}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // สีสำหรับสถานะต่างๆ
  Color getStatusColor(String? status) {
    switch (status) {
      case 'Low':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey; // หากไม่มีสถานะ
    }
  }

  // ฟังก์ชันนำทางไปยังหน้า Notification
  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ใช้สถานะและวันที่จาก Widget
    String status = widget.status ?? 'No Data'; // สถานะค่าเริ่มต้น
    DateTime date = widget.date ?? DateTime.now(); // วันที่ค่าเริ่มต้น

    return DefaultTabController(
      length: 2, // จำนวนแท็บ
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.lightBlue[100],
                expandedHeight: 500.0, // ปรับขนาด SliverAppBar
                floating: false,
                pinned: true,
                actions: [
                  // ไอคอนกระดิ่ง
                  IconButton(
                    icon:
                        Icon(Icons.notifications_outlined, color: Colors.black),
                    onPressed: _navigateToNotifications, // นำทางเมื่อกด
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 70.0), // ตำแหน่ง Title
                  background: Stack(
                    children: [
                      ClipPath(
                        clipper: CurvedClipper(),
                        child: Container(
                          color: Colors.purple[100],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // วันที่
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${date.day} ${_getMonthName(date.month)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),

                                  // สถานะ
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: getStatusColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 10),

                                  // วงกลมที่เปลี่ยนสีตามสถานะ
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: getStatusColor(status),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: Offset(6, 12),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 90,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0), // ความสูงของ TabBar
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(
                          icon: FaIcon(FontAwesomeIcons.carrot),
                          text: "HealthFood for you"),
                      Tab(
                          icon: FaIcon(FontAwesomeIcons.dumbbell),
                          text: "Health inside"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              AttractionsScreen(), // AttractionsScreen
              ExerciseScreen(), // ExerciseScreen
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับดึงชื่อเดือน
  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}

// หน้าสำหรับ Notification
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'This is the Notification Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 120);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 120);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
