import 'package:emib_hospital/pages/recommend_pages.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BloodPressureLogger extends StatefulWidget {
  final Function(DateTime, int, int, int, String) onSave;

  BloodPressureLogger({required this.onSave});

  @override
  _BloodPressureLoggerState createState() => _BloodPressureLoggerState();
}

class _BloodPressureLoggerState extends State<BloodPressureLogger> {
  DateTime _selectedDay = DateTime.now();
  TextEditingController _sysController = TextEditingController();
  TextEditingController _diaController = TextEditingController();
  TextEditingController _pulController = TextEditingController();

  String getStatus(int sys, int dia) {
    if (sys < 90 || dia < 60) {
      return 'Low';
    } else if (sys > 140 || dia > 90) {
      return 'High';
    } else {
      return 'Normal';
    }
  }

  void _saveRecord() {
    int sys = int.parse(_sysController.text);
    int dia = int.parse(_diaController.text);
    int pul = int.parse(_pulController.text);

    String status = getStatus(sys, dia);

    widget.onSave(_selectedDay, sys, dia, pul, status);

    _clearFields();
  }

  void _clearFields() {
    _sysController.clear();
    _diaController.clear();
    _pulController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // แถบด้านบนที่มีไอคอนเมนูและการแจ้งเตือน
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ปฏิทิน
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _selectedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.blueAccent),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.blueAccent),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),

            // แถบป้อนข้อมูลสีส้ม
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.orangeAccent),
                          SizedBox(width: 8),
                          Text(
                            '${_selectedDay.day} ${_getMonthName(_selectedDay.month)} ${_selectedDay.year}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTextField(
                              'SYS', _sysController, Icons.favorite),
                          _buildTextField(
                              'DIA', _diaController, Icons.favorite_border),
                          _buildTextField(
                              'PUL', _pulController, Icons.heart_broken),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _saveRecord();
                          },
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text('Save',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orangeAccent),
            SizedBox(width: 4),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

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
    ////..
  }
}
