import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BloodPressureLogger extends StatefulWidget {
  final Function(DateTime, int, int, int, String) onSave;

  const BloodPressureLogger({required this.onSave, Key? key}) : super(key: key);

  @override
  _BloodPressureLoggerState createState() => _BloodPressureLoggerState();
}

class _BloodPressureLoggerState extends State<BloodPressureLogger> {
  DateTime _selectedDay = DateTime.now();
  final TextEditingController _sysController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _pulController = TextEditingController();

  final List<String> _months = [
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
    if (validateInput()) {
      int sys = int.parse(_sysController.text);
      int dia = int.parse(_diaController.text);
      int pul = int.parse(_pulController.text);

      String status = getStatus(sys, dia);

      widget.onSave(_selectedDay, sys, dia, pul, status);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record Saved!')),
      );

      _clearFields();
    }
  }

  bool validateInput() {
    if (_sysController.text.isEmpty ||
        _diaController.text.isEmpty ||
        _pulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }

    try {
      int.parse(_sysController.text);
      int.parse(_diaController.text);
      int.parse(_pulController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid numbers')),
      );
      return false;
    }
    return true;
  }

  void _clearFields() {
    _sysController.clear();
    _diaController.clear();
    _pulController.clear();
  }

  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Month'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _months.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_months[index]),
                  onTap: () {
                    setState(() {
                      _selectedDay = DateTime(_selectedDay.year, index + 1, 1);
                    });
                    Navigator.of(context).pop(); // ปิด Dialog
                    Navigator.of(context).pop(); // ปิด Drawer
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.orangeAccent),
              title: Text('Month'),
              onTap: _showMonthPicker,
            ),
            // เพิ่มตัวเลือกอื่นๆ ใน Drawer ได้ที่นี่
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
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
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.blueAccent),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.blueAccent),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
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
                            '${_selectedDay.day} ${_months[_selectedDay.month - 1]} ${_selectedDay.year}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
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
                          onPressed: _saveRecord,
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
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
}
