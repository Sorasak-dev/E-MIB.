import 'package:flutter/material.dart';
import 'unread_notifications.dart'; // นำเข้าหน้า UnreadNotifications
import 'read_notifications.dart';   // นำเข้าหน้า ReadNotifications
import 'package:material_segmented_control/material_segmented_control.dart'; // นำเข้าแพ็กเกจ

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentSelection = 0; // สถานะของการเลือก Unread/Read

  final Map<int, Widget> _tabs = <int, Widget>{
    0: Text(
      'UNREAD',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    1: Text(
      'READ',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  };

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
      drawer: Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              width: double.infinity,
              child: MaterialSegmentedControl(
                children: _tabs,
                selectionIndex: _currentSelection,
                borderColor: Colors.blueGrey.shade200,
                selectedColor: Color(0xFFc4e9fc),
                unselectedColor: Colors.white,
                borderRadius: 30.0,
                selectedTextStyle: TextStyle(color: Colors.black),
                unselectedTextStyle: TextStyle(color: Colors.black),
                onSegmentTapped: (int index) {
                  setState(() {
                    _currentSelection = index;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: _currentSelection == 0
                ? UnreadNotifications()
                : ReadNotifications(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFcacafe),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: 2, // ค่าคงที่เพื่อแสดงสถานะไอคอนปัจจุบัน
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
          onTap: (index) {
            Navigator.pop(context, index); // ส่งค่า index กลับไปหน้า MainScreen
          },
        ),
      ),
    );
  }
}
