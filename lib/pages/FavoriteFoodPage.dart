import 'package:flutter/material.dart';

class FavoriteFoodPage extends StatefulWidget {
  final List<dynamic> favorites;
  final Function(dynamic) onFavoriteToggle;
  final Function(dynamic) onDelete; // ฟังก์ชันสำหรับลบรายการ

  const FavoriteFoodPage({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  State<FavoriteFoodPage> createState() => _FavoriteFoodPageState();
}

class _FavoriteFoodPageState extends State<FavoriteFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรด'),
      ),
      body: widget.favorites.isEmpty
          ? const Center(child: Text('ไม่มีรายการโปรด'))
          : ListView.builder(
              itemCount: widget.favorites.length,
              itemBuilder: (context, index) {
                final food = widget.favorites[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      getFoodEmoji(food['food_categoryname'] ?? ''),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(food['food_name'] ?? 'ไม่มีชื่ออาหาร'),
                  subtitle: Text(
                    'หมวดหมู่: ${food['food_categoryname'] ?? 'ไม่ระบุ'}\n'
                    '${food['Description'] ?? 'ไม่มีคำอธิบาย'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onDelete(food); // ลบรายการจากรายการโปรด
                      setState(() {
                        // อัปเดตหน้า FavoriteFoodPage ทันที
                        widget.favorites.remove(food);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }

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
        return '🍽️'; // อีโมจิเริ่มต้นถ้าไม่มีหมวดหมู่
    }
  }
}
