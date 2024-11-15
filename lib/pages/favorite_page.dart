import 'package:flutter/material.dart';
class FavoritePage extends StatefulWidget {
  final List<dynamic> favorites;
  final Function(dynamic) onFavoriteToggle;
  final Function(dynamic) onDelete; // ฟังก์ชันสำหรับลบรายการ

  const FavoritePage({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
                final attraction = widget.favorites[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      getFoodEmoji(attraction['food_categoryname'] ?? ''),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(attraction['food_name']),
                  subtitle: Text(
                    'หมวดหมู่: ${attraction['food_categoryname']}\n${attraction['Description']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onDelete(attraction); // ลบรายการจากรายการโปรด
                      setState(() {
                        // อัปเดตหน้า FavoritePage ทันที
                        widget.favorites.remove(attraction);
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
