import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExerciseDetailScreen extends StatefulWidget {
  final int id;

  const ExerciseDetailScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _ExerciseDetailScreenState();
  }
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Map<String, dynamic>? _exerciseDetail;

  String getFoodEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'grains':
        return '🌾';
      case 'vegetable':
        return '🥦';
      case 'dairy':
        return '🧀';
      case 'fruit':
        return '🍎';
      case 'meat':
        return '🍖';
      case 'drink':
        return '🥤';
      default:
        return '🍽️'; // อีโมจิเริ่มต้นหากไม่ตรงกับหมวดหมู่
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExerciseDetail();
  }

  Future<void> _fetchExerciseDetail() async {
  try {
    final response = await http.get(
      Uri.parse('https://my.api.mockaroo.com/e.json?key=9a646df0'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data from API: $data"); // พิมพ์ข้อมูล API ที่ได้มาเพื่อตรวจสอบ

      if (data is List && data.isNotEmpty) {
        setState(() {
          _exerciseDetail = data.firstWhere((item) => item['id'] == widget.id, orElse: () => null);
        });
      } else {
        setState(() {
          _exerciseDetail = {};
        });
      }
    } else {
      print("Failed to load data: ${response.statusCode}");
      setState(() {
        _exerciseDetail = {};
      });
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      _exerciseDetail = {};
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดออกกำลังกาย'),


      ),
      body: _exerciseDetail == null
          ? const Center(child: CircularProgressIndicator())
          : _exerciseDetail!.isEmpty
              ? const Center(child: Text('ข้อมูลไม่พร้อมใช้งาน'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // แสดงรูปภาพจาก URL ถ้ามี หรือแสดงรูปเริ่มต้นถ้าไม่มี
                      if (_exerciseDetail!['image_url'] != null)
                        Image.network(
                          _exerciseDetail!['image_url'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.asset(
                          'assets/default_image.jpg', // รูปภาพเริ่มต้นที่จัดเตรียมในโปรเจค
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _exerciseDetail!['Exercise_Name'] ?? 'ไม่ระบุชื่ออาหาร',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ระยะเวลา: ${_exerciseDetail!['Duration'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เหมาะสำหรับ: ${_exerciseDetail!['Target Group'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _exerciseDetail!['Description'] ?? 'ไม่มีคำอธิบาย',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
    );
  }
}
