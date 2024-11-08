import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure Logger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BloodPressureLogger(), // เรียกหน้า BloodPressureLogger ทันที
    );
  }
}

class BloodPressureLogger extends StatefulWidget {

  final String? userId;

  const BloodPressureLogger({Key? key, this.userId}) : super(key: key);

  @override
  _BloodPressureLoggerState createState() => _BloodPressureLoggerState();
}

class _BloodPressureLoggerState extends State<BloodPressureLogger> {
  DateTime _selectedDay = DateTime.now(); // วันที่ที่เลือก
  TextEditingController _sysController =
      TextEditingController(); // สำหรับบันทึก SYS
  TextEditingController _diaController =
      TextEditingController(); // สำหรับบันทึก DIA
  TextEditingController _pulController =
      TextEditingController(); // สำหรับบันทึก PUL


  // เก็บค่าที่บันทึกใน Map
  Map<DateTime, Map<String, int>> _savedRecords = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกความดันโลหิต'),
      ),
      body: Column(
        children: [
          // ปฏิทิน
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) {
              return isSameDay(
                  _selectedDay, day); // เช็คว่าวันที่เลือกตรงกันหรือไม่
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay; // อัปเดตวันที่เมื่อเลือก
              });
            },
          ),
          SizedBox(height: 20),
          // แบบฟอร์มบันทึกความดัน
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextField('SYS', _sysController),
                    _buildTextField('DIA', _diaController),
                    _buildTextField('PUL', _pulController),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _saveRecord(); // ฟังก์ชันสำหรับบันทึกค่า
                  },
                  child: Text('บันทึก'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างช่องกรอกข้อมูล
  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(label), // แสดงชื่อ เช่น SYS, DIA, PUL
        SizedBox(
          width: 70,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number, // รับเฉพาะตัวเลข
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'mmHg', // ข้อความที่แสดงในช่องกรอก
            ),
          ),
        ),
      ],
    );
  }

  // ฟังก์ชันบันทึกข้อมูล
  Future<void> _saveRecord() async {
    setState(() {
      log("UserId: ${widget.userId}");
      // บันทึกค่าที่กรอกใน Map
      _savedRecords[_selectedDay] = {
        'SYS': int.parse(_sysController.text),
        'DIA': int.parse(_diaController.text),
        'PUL': int.parse(_pulController.text),
      };
    });

    // สร้าง documentId ที่จะใช้ในการเช็ค
    String documentId = widget.userId! + _selectedDay.toIso8601String();
    // ตรวจสอบว่ามี document อยู่แล้วหรือไม่
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('blood_pressure_records')
        .doc(documentId);


    try {
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // ถ้ามี document อยู่แล้ว อัปเดตข้อมูล
        await docRef.update({
          'SYS': int.parse(_sysController.text),
          'DIA': int.parse(_diaController.text),
          'PUL': int.parse(_pulController.text),
          'date': _selectedDay,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('อัปเดตข้อมูลสำเร็จสำหรับวันที่ $_selectedDay'),
        ));
      } else {
        // ถ้าไม่มี document ให้สร้างใหม่
        await docRef.set({
          'userId': widget.userId,
          'date': _selectedDay,
          'SYS': int.parse(_sysController.text),
          'DIA': int.parse(_diaController.text),
          'PUL': int.parse(_pulController.text),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('บันทึกข้อมูลสำเร็จสำหรับวันที่ $_selectedDay'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $error'),
      ));
    }

    // แสดงข้อความยืนยันการบันทึก
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('บันทึกข้อมูลสำเร็จสำหรับวันที่ $_selectedDay'),
    ));

    _clearFields(); // ล้างข้อมูลในช่องกรอกหลังบันทึก
  }

  // ฟังก์ชันล้างข้อมูลในช่องกรอก
  void _clearFields() {
    _sysController.clear();
    _diaController.clear();
    _pulController.clear();
  }
}
