import 'package:flutter/material.dart';
import 'package:emib_hospital/user/firstpage/notification_service.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // ดึงรายการแจ้งเตือนจาก NotificationService
    final notifications = NotificationService.getNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlue[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.black),
                  title: Text(notification['title'] ?? 'No Title'),
                  subtitle: Text(notification['body'] ?? 'No Body'),
                );
              },
            ),
    );
  }
}
