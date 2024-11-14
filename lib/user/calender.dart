import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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


  @override
  void initState() {
    super.initState();
    _fetchRecord(_selectedDay);
  }

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
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            selectedDayPredicate: (day) {
              return isSameDay(
                  _selectedDay, day); // เช็คว่าวันที่เลือกตรงกันหรือไม่
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay; // อัปเดตวันที่เมื่อเลือก
              });
              _fetchRecord(selectedDay); // เรียกฟังก์ชันดึงข้อมูล
            },
          ),
          SizedBox(height: 20),
          // แบบฟอร์มบันทึกความดัน
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF5EAD4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('d MMMM').format(_selectedDay),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTextField('SYS', _sysController, 'mmHg'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity, // กำหนดความกว้างของเส้น
                    height: 1.0, // ความหนาของเส้น
                    decoration: BoxDecoration(
                      color: Colors.black, // สีของเส้น
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTextField('DIA', _diaController, 'mmHg'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity, // กำหนดความกว้างของเส้น
                    height: 1.0, // ความหนาของเส้น
                    decoration: BoxDecoration(
                      color: Colors.black, // สีของเส้น
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTextField('PUL', _pulController, 'min     '),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _saveRecord();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('save', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างช่องกรอกข้อมูล
  Widget _buildTextField(
      String label, TextEditingController controller, String unit) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(width: 30),
        SizedBox(
          height: 40,
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 30),
        Text(unit, style: TextStyle(fontSize: 14, color: Colors.grey)),
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

    String currentDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    log(currentDate);

    try {
      // ค้นหาเอกสารที่มี userId และ date ตรงกัน
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('blood_pressure_records')
          .where('userId', isEqualTo: widget.userId)
          .where('date', isEqualTo: currentDate)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // ถ้ามี document อยู่แล้ว อัปเดตข้อมูล
        await querySnapshot.docs.first.reference.update({
          'SYS': int.parse(_sysController.text),
          'DIA': int.parse(_diaController.text),
          'PUL': int.parse(_pulController.text),
          'date': currentDate,
        });
        log("Update ==>");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('อัปเดตข้อมูลสำเร็จสำหรับวันที่ $currentDate'),
        ));
      } else {
        // ถ้าไม่มี document ให้สร้างใหม่
        await FirebaseFirestore.instance.collection('blood_pressure_records').add({
          'userId': widget.userId,
          'date': currentDate,
          'SYS': int.parse(_sysController.text),
          'DIA': int.parse(_diaController.text),
          'PUL': int.parse(_pulController.text),
        });
        log("Insert ==>");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('บันทึกข้อมูลสำเร็จสำหรับวันที่ $currentDate'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $error'),
      ));
      _clearFields();
    }

    //_clearFields(); // ล้างข้อมูลในช่องกรอกหลังบันทึก
  }

  Future<void> _fetchRecord(DateTime selectedDay) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('blood_pressure_records')
          .where('userId', isEqualTo: widget.userId)
          .where('date', isEqualTo: currentDate)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // ถ้ามีข้อมูลที่ตรงกับวันที่และ userId ที่เลือก
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _sysController.text = data['SYS'].toString();
          _diaController.text = data['DIA'].toString();
          _pulController.text = data['PUL'].toString();
        });
      } else {
        // ถ้าไม่มีข้อมูล ให้ล้างช่องกรอก
        _clearFields();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('เกิดข้อผิดพลาดในการดึงข้อมูล: $error'),
      ));
    }
  }

  // ฟังก์ชันล้างข้อมูลในช่องกรอก
  void _clearFields() {
    _sysController.clear();
    _diaController.clear();
    _pulController.clear();
  }
}
