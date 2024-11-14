import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emib_hospital/user/calender.dart';
import 'package:flutter/material.dart';
import 'package:emib_hospital/Nevigation/notification_page.dart';
import 'package:emib_hospital/user/firstpage/setting.dart';
import 'package:intl/intl.dart';

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
  final String? userId;

  const MyHomePage({Key? key, this.userId}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ตัวแปรสำหรับปรับขนาดและตำแหน่งของวงกลม
  double circleSize = 200;
  double circlePositionX = 0; // ปรับตำแหน่งในแกน X
  double circlePositionY = -0.2; // ปรับตำแหน่งในแกน Y

  String sysValue = "Loading...";
  String diaValue = "Loading...";
  String pulValue = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchBloodPressureData();
  }

  Future<void> fetchBloodPressureData() async {
    // กำหนดวันที่ปัจจุบันในรูปแบบ YYYY-MM-DD
    DateTime customDate = DateTime(2024, 11, 14);
    String currentDate = DateFormat('yyyy-MM-dd').format(customDate);
    log(currentDate);
    // ค้นหาข้อมูลจาก Firebase ตาม userId และวันที่
    var snapshot = await FirebaseFirestore.instance
        .collection('blood_pressure_records')
        .where('userId', isEqualTo: widget.userId)
        .where('date', isEqualTo: currentDate)
        .get();
    // ตรวจสอบว่ามีข้อมูลหรือไม่
    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data();
      setState(() {
        sysValue = "${data['SYS']}";
        diaValue = "${data['DIA']}";
        pulValue = "${data['PUL']}";
      });
    } else {
      setState(() {
        sysValue = "No data";
        diaValue = "No data";
        pulValue = "No data";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/hospital_logo.png'),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'โรงพยาบาล E-MIB',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      'E-MIB HOSPITAL',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {
                // นำทางไปยังหน้า NotificationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchBloodPressureData,
        child: ListView(
          children: [
            Column(
              children: [
                // ส่วนของวงกลมและปุ่ม More
                Stack(
                  children: [
                    ClipPath(
                      clipper: CurvedClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.70,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                        ),
                        child: Stack(
                          children: [
                            // ปรับตำแหน่งแกน X และ Y ของวงกลม
                            Align(
                              alignment: Alignment(circlePositionX, circlePositionY),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Normal',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA6E1A1),
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
                                        '${DateTime.now().day}',
                                        style: TextStyle(
                                          fontSize: 90,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatCard('SYS', "mmHg" ,sysValue),
                                      _buildStatCard('DIA', "mmHg" ,diaValue),
                                      _buildStatCard('PUL', "min" ,pulValue),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 80.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BloodPressureLogger(userId: widget.userId)),
                                    );
                                  },
                                  child: Text('More'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    textStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ส่วนของ 3 กล่องข้อมูล
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildInfoCard('why it important', Colors.orange[100]),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildInfoCard('24/7 Medicine', Colors.yellow[100]),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildInfoCard('Find The Doctors Near You', Colors.blue[100]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // ส่วนของ "3 Easy steps"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 Easy steps \nhelp you start',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildStepCard(
                                '1',
                                'sign in and create your profile',
                                Colors.orange[100],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildStepCard(
                                '2',
                                'measure your Blood pressure and Record',
                                Colors.blue[100],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildStepCard(
                                '3',
                                'Get you advice and select your daily plan',
                                Colors.lightBlue[100],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


    Widget _buildStatCard(String title,String unit, String value) {
      return Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

  // ฟังก์ชันสร้างการ์ดข้อมูล (ส่วนกล่องที่มีลูกศร)
  Widget _buildInfoCard(String text, Color? color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18, // Increased font size
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.blue,
                size: 24, // Adjusted icon size
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดสำหรับ "3 Easy steps"
  Widget _buildStepCard(String stepNumber, String text, Color? color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              stepNumber,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // เริ่มต้นที่มุมซ้ายบน
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
