import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecommendPages extends StatefulWidget {
  final DateTime? selectedDate;
  final int? sys;
  final int? dia;
  final int? pul;
  final String? status;

  const RecommendPages({
    Key? key,
    this.selectedDate,
    this.sys,
    this.dia,
    this.pul,
    this.status,
  }) : super(key: key);

  @override
  State<RecommendPages> createState() => _RecommendPagesState();
}

class _RecommendPagesState extends State<RecommendPages> {
  // ตัวแปรใน State
  DateTime? _selectedDate;
  int? _sys;
  int? _dia;
  int? _pul;
  String? _status;

  @override
  void initState() {
    super.initState();
    // ตั้งค่าข้อมูลเริ่มต้นจาก Widget
    _selectedDate = widget.selectedDate;
    _sys = widget.sys;
    _dia = widget.dia;
    _pul = widget.pul;
    _status = widget.status;
  }

  // ฟังก์ชันลบข้อมูล
  void _clearData() {
    setState(() {
      _selectedDate = null;
      _sys = null;
      _dia = null;
      _pul = null;
      _status = null;
    });
  }

  // กำหนดสีของสถานะ
  Color getStatusColor(String? status) {
    switch (status) {
      case 'Low':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // ไอคอนแจ้งเตือน
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                  ],
                ),

                // วันที่และสถานะ
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)}'
                            : 'No data recorded',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: getStatusColor(_status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          _status ?? 'No Status',
                          style: TextStyle(
                            color: getStatusColor(_status),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ข้อมูลความดันโลหิต
                _sys != null && _dia != null && _pul != null
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataRow('SYS', _sys, 'mmHg'),
                            _buildDataRow('DIA', _dia, 'mmHg'),
                            _buildDataRow('PUL', _pul, 'min'),
                          ],
                        ),
                      )
                    : Text(
                        'No blood pressure data available',
                        style: TextStyle(color: Colors.grey),
                      ),

                SizedBox(height: 16),

                // ปุ่มลบข้อมูล
                ElevatedButton(
                  onPressed: _clearData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // สีปุ่ม
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'ClearData',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                SizedBox(height: 16),

                // คำแนะนำ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Recommendations',
                      style: TextStyle(
                          color: Color.fromARGB(255, 86, 80, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // คำเตือนตามสถานะ
                ..._buildWarnings(_status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างแถวข้อมูล (SYS, DIA, PUL)
  Widget _buildDataRow(String label, int? value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 60,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              value?.toString() ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            width: 60,
            alignment: Alignment.centerLeft,
            child: Text(
              unit,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างคำเตือน
  List<Widget> _buildWarnings(String? status) {
    List<Map<String, dynamic>> recommendations = [];

    switch (status) {
      case 'Low':
        recommendations = [
          {
            'icon': FontAwesomeIcons.utensils,
            'color': Colors.orange,
            'title': 'เพิ่มโซเดียมในอาหาร',
            'subtitle': 'ทานอาหารเค็มเล็กน้อยเพื่อช่วยปรับสมดุลความดันโลหิต',
          },
          {
            'icon': FontAwesomeIcons.water,
            'color': Colors.blue,
            'title': 'ดื่มน้ำให้เพียงพอ',
            'subtitle': 'การดื่มน้ำช่วยเพิ่มการไหลเวียนโลหิต',
          },
          {
            'icon': FontAwesomeIcons.bed,
            'color': Colors.purple,
            'title': 'พักผ่อนให้เพียงพอ',
            'subtitle': 'นอนหลับพักผ่อนให้ร่างกายฟื้นฟูสมดุล',
          },
        ];
        break;
      case 'High':
        recommendations = [
          {
            'icon': FontAwesomeIcons.walking,
            'color': Colors.red,
            'title': 'ลดความเครียด',
            'subtitle': 'ฝึกสมาธิหรือทำกิจกรรมที่ช่วยผ่อนคลายจิตใจ',
          },
          {
            'icon': FontAwesomeIcons.appleAlt,
            'color': Colors.green,
            'title': 'รับประทานผลไม้ที่มีโพแทสเซียม',
            'subtitle': 'กล้วย ส้ม และผักใบเขียวช่วยลดความดันโลหิต',
          },
          {
            'icon': FontAwesomeIcons.prescriptionBottleAlt,
            'color': Colors.blueGrey,
            'title': 'ปฏิบัติตามคำแนะนำแพทย์',
            'subtitle': 'รับประทานยาตามแพทย์สั่งอย่างเคร่งครัด',
          },
        ];
        break;
      case 'Normal':
        recommendations = [
          {
            'icon': FontAwesomeIcons.smile,
            'color': Colors.green,
            'title': 'รักษาอาหารที่มีประโยชน์',
            'subtitle': 'ทานอาหารครบ 5 หมู่เพื่อสุขภาพที่ดี',
          },
          {
            'icon': FontAwesomeIcons.dumbbell,
            'color': Colors.blueGrey,
            'title': 'ออกกำลังกายสม่ำเสมอ',
            'subtitle': 'การออกกำลังกายช่วยรักษาระดับความดันให้คงที่',
          },
          {
            'icon': FontAwesomeIcons.heart,
            'color': Colors.pink,
            'title': 'ตรวจสุขภาพเป็นประจำ',
            'subtitle': 'ตรวจความดันโลหิตเพื่อเฝ้าระวังความเสี่ยง',
          },
        ];
        break;
      default:
        recommendations = [
          {
            'icon': FontAwesomeIcons.questionCircle,
            'color': Colors.grey,
            'title': 'ไม่มีคำแนะนำ',
            'subtitle': 'กรุณาบันทึกข้อมูลเพื่อรับคำแนะนำที่เหมาะสม',
          },
        ];
        break;
    }

    return recommendations
        .map((rec) => _buildWarningContainer(
              rec['icon'],
              rec['color'],
              rec['title'],
              rec['subtitle'],
            ))
        .toList();
  }

  // ฟังก์ชันสร้างกล่องคำเตือน
  Widget _buildWarningContainer(
      IconData icon, Color? iconColor, String title, String subtitle) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 1.0, right: 16.0),
          child: FaIcon(
            icon,
            size: 36,
            color: iconColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[900]),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันแปลงเดือน
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
