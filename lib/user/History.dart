import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> records; // รับข้อมูลประวัติ
  final Function(int) onDelete; // ฟังก์ชันสำหรับลบข้อมูล

  const HistoryPage({
    Key? key,
    required this.records,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Colors.purple[100],
      ),
      body: records.isEmpty
          ? Center(
              child: Text(
                "No records found",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(record['status']),
                      child: Text(
                        record['status'][0], // ตัวอักษรแรกของสถานะ
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "Date: ${DateFormat('dd/MM/yyyy').format(record['date'])}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "SYS: ${record['sys']} | DIA: ${record['dia']} | PUL: ${record['pul']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onDelete(index); // ลบข้อมูลเมื่อกดปุ่มลบ
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ฟังก์ชันคืนค่าสีตามสถานะ
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Low':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
