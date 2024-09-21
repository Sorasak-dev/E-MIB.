import 'package:flutter/material.dart';
import 'notification_card.dart'; // นำเข้า NotificationCard ที่แยกไว้

class ReadNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        NotificationCard(
          icon: Icons.calendar_today,
          title: 'บันทึกความดันในอดีต',
        ),
      ],
    );
  }
}
