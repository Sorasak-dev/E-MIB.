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
                // Notification Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                  ],
                ),

                // Date and Status Display
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.selectedDate != null
                            ? '${widget.selectedDate!.day} ${_getMonthName(widget.selectedDate!.month)}'
                            : 'No data recorded ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.status ?? '',
                        style: TextStyle(
                          color: getStatusColor(widget.status),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Display Blood Pressure Data
                widget.sys != null && widget.dia != null && widget.pul != null
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFBBE9FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataRow('SYS', widget.sys, 'mmHg'),
                            _buildDataRow('DIA', widget.dia, 'mmHg'),
                            _buildDataRow('PUL', widget.pul, 'min'),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),

                SizedBox(height: 16),

                // Warning Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Warning',
                      style: TextStyle(
                          color: Color.fromARGB(255, 86, 80, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Warning Containers
                _buildWarningContainer(
                  FontAwesomeIcons.pepperHot,
                  Color.fromARGB(255, 255, 176, 87),
                  'ระมัดระวังการรับประทานอาหารจำพวกพริก',
                  'ข้อมูลเพิ่มเติม: สารในพริกบางชนิดที่อาจทำให้เกิดอาการได้',
                ),

                SizedBox(height: 16),

                _buildWarningContainer(
                  FontAwesomeIcons.candyCane,
                  Colors.pink[300],
                  'Low sweet',
                  'ข้อมูลเพิ่มเติม: ทานของหวานมากเกินทำให้เกิดผลเสียมากขึ้น',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, int? value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 120, // Set equal width for all fields
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
          SizedBox(width: 16),
          Text(
            unit,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningContainer(
      IconData icon, Color? iconColor, String title, String subtitle) {
    return Container(
      width: double.infinity,
      height: 150,
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
