import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // จำนวนคอลัมน์
            crossAxisSpacing: 16.0, // ระยะห่างระหว่างคอลัมน์
            mainAxisSpacing: 16.0, // ระยะห่างระหว่างแถว
            childAspectRatio: 0.75, // อัตราส่วนขนาดของแต่ละกรอบ
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            // แยกฟังก์ชันการนำทางของแต่ละกรอบ
            return Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8, // ระยะห่างจากล่าง
                    left: 8, // ระยะห่างจากซ้าย
                    child: ElevatedButton(
                      onPressed: () {
                        // นำทางไปยังหน้าต่างๆ แบบแยกกันโดยตรง
                        //if (index == 0) {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(builder: (context) => Page1()),
                        //  );
                        // } else if (index == 1) {
                        //  Navigator.push(
                        //    context,
                        //   MaterialPageRoute(builder: (context) => Page2()),
                        //  );
                        // } else if (index == 2) {
                        //  Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => Page3()),
                        //    );
                        //  } else if (index == 3) {
                        //  Navigator.push(
                        //  context,
                        //   MaterialPageRoute(builder: (context) => Page4()),
                        //  );
                        // } else if (index == 4) {
                        //   Navigator.push(
                        //     context,
                        //    MaterialPageRoute(builder: (context) => Page5()),
                        //  );
                        //  } else if (index == 5) {
                        //   Navigator.push(
                        //     context,
                        //    MaterialPageRoute(builder: (context) => Page6()),
                        //  );
                        //  }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8), // ปรับขนาดของปุ่ม
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('more', style: TextStyle(color: Colors.blue)),
                          Icon(Icons.arrow_forward, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
