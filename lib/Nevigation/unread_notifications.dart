import 'package:flutter/material.dart';
import 'notification_card.dart'; // นำเข้า NotificationCard ที่แยกไว้

class UnreadNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        NotificationCard(
          icon: Icons.calendar_today,
          title: 'บันทึกความดันประจำวัน',
        ),
        NotificationCard(
          icon: Icons.notifications,
          title: 'ควรรับประทานน้ำให้มากๆ',
        ),
        NotificationCard(
          icon: Icons.notifications,
          title: 'New!! ความดันฉันอาจร้ายกว่าที่คิด',
        ),
        NotificationCard(
          icon: Icons.calendar_today,
          title: 'บันทึกความดัน',
        ),
      ],
    );
  }
}
