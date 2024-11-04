import 'package:emib_hospital/user/calender.dart';
import 'package:flutter/material.dart';

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
            Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                                'Today', // ข้อความที่ต้องการใส่เหนือวงกลม
                                style: TextStyle(
                                  fontSize: 24, // ขนาดตัวอักษร
                                  color: Colors.grey, // สีตัวอักษร
                                  fontWeight: FontWeight.bold,
                                ),
                              ),Text(
                                'Normal', // ข้อความที่ต้องการใส่เหนือวงกลม
                                style: TextStyle(
                                  fontSize: 40, // ขนาดตัวอักษร
                                  color: Colors.blueAccent, // สีตัวอักษร
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10), // ระยะห่างระหว่างข้อความและวงกลม
                              Container(
                                width: circleSize,
                                height: circleSize,
                                decoration: BoxDecoration(
                                  color: Color(0xFFA6E1A1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // สีขอบ
                                    width: 2, // ความกว้างของขอบ
                                     ),
                                  boxShadow: [
                                    BoxShadow( color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(6, 12), // เงาในแนวตั้งเท่านั้น
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${DateTime.now().day}', // ใส่วันปัจจุบันในวงกลม
                                    style: TextStyle(
                                      fontSize: 90,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),



                        // ปุ่ม More ที่มีพื้นหลังสีขาวและตัวอักษรสีฟ้า
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 80.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // โค้ดสำหรับการกระทำของปุ่ม "More"
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BloodPressureLogger(
                                      userId: widget.userId
                                  )),
                                );
                              },
                              child: Text('More'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // พื้นหลังสีขาว
                                foregroundColor: Colors.blue, // ตัวอักษรสีฟ้า
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // ลดระยะขอบข้างลง
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // จัดให้มีช่องว่างเท่าๆ กัน
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 3 / 4, // อัตราส่วน 3:4 (ทำให้ยาวลง)
                      child:
                          _buildInfoCard('why it improtan', Colors.orange[100]),
                    ),
                  ),
                  SizedBox(width: 8), // เพิ่มระยะห่างเล็กน้อยระหว่างกล่อง
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child:
                          _buildInfoCard('24/7 Medicine', Colors.yellow[100]),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: _buildInfoCard(
                          'Find The Doctors Near You', Colors.blue[100]),
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
                    // ใช้ IntrinsicHeight เพื่อบังคับให้การ์ดทั้งหมดสูงเท่ากัน
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
      ),
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
