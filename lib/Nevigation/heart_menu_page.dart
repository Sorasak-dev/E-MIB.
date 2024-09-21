import 'package:flutter/material.dart';

class HeartMenuPage extends StatelessWidget {
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // จำนวนบล็อคต่อแถว
            crossAxisSpacing: 16.0, // ระยะห่างระหว่างบล็อคแนวนอน
            mainAxisSpacing: 16.0, // ระยะห่างระหว่างบล็อคแนวตั้ง
            childAspectRatio: 3 / 4, // อัตราส่วนความกว้าง/ความสูงของบล็อค
          ),
          itemCount: 6, // จำนวนบล็อคที่ต้องการแสดง
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20), // ขอบโค้งมนของบล็อค
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // สีพื้นหลังของปุ่ม
                        foregroundColor: Colors.blue, // สีตัวอักษรและไอคอน
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        // การทำงานเมื่อกดปุ่ม more
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'more',
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFE8E8F3),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // ตั้งค่าให้ตรงกับหน้า heart
        onTap: (index) {
          // การทำงานเมื่อกดปุ่ม bottom navigation
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
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
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
