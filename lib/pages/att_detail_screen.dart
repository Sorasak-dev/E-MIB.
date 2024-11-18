import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttractionDetailScreen extends StatefulWidget {
  final int id;

  const AttractionDetailScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _AttractionDetailScreenState();
  }
}

class _AttractionDetailScreenState extends State<AttractionDetailScreen> {
  Map<String, dynamic>? _attractionDetail;

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
    _fetchAttractionDetail();
  }

  Future<void> _fetchAttractionDetail() async {
  try {
    final response = await http.get(
      Uri.parse('https://my.api.mockaroo.com/food.json?key=9a646df0'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data from API: $data"); // พิมพ์ข้อมูล API ที่ได้มาเพื่อตรวจสอบ

      if (data is List && data.isNotEmpty) {
        setState(() {
          _attractionDetail = data.firstWhere((item) => item['id'] == widget.id, orElse: () => null);
        });
      } else {
        setState(() {
          _attractionDetail = {};
        });
      }
    } else {
      print("Failed to load data: ${response.statusCode}");
      setState(() {
        _attractionDetail = {};
      });
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      _attractionDetail = {};
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดอาหาร'),


      ),
      body: _attractionDetail == null
          ? const Center(child: CircularProgressIndicator())
          : _attractionDetail!.isEmpty
              ? const Center(child: Text('ข้อมูลไม่พร้อมใช้งาน'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // แสดงรูปภาพจาก URL ถ้ามี หรือแสดงรูปเริ่มต้นถ้าไม่มี
                      if (_attractionDetail!['image_url'] != null)
                        Image.network(
                          _attractionDetail!['image_url'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      else
                        /*Image.asset(
                          'assets/default_image.jpg', // รูปภาพเริ่มต้นที่จัดเตรียมในโปรเจค
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),*/
                      const SizedBox(height: 16),
                      Text(
                        _attractionDetail!['food_name'] ?? 'ไม่ระบุชื่ออาหาร',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'หมวดหมู่: ${_attractionDetail!['food_categoryname'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เหมาะสำหรับ: ${_attractionDetail!['Suitable For'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'แคลอรี่: ${_attractionDetail!['calories'] ?? 'ไม่ระบุ'} กิโลแคลอรี่',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'โปรตีน: ${_attractionDetail!['protein'] ?? 'ไม่ระบุ'} กรัม\n'
                        'ไขมัน: ${_attractionDetail!['fat'] ?? 'ไม่ระบุ'} กรัม\n'
                        'คาร์โบไฮเดรต: ${_attractionDetail!['carbohydrates'] ?? 'ไม่ระบุ'} กรัม',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _attractionDetail!['Description'] ?? 'ไม่มีคำอธิบาย',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
    );
  }
}
