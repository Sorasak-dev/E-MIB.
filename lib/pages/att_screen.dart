import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/att_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:emib_hospital/user/favorite_page.dart';

class AttractionsScreen extends StatefulWidget {
  const AttractionsScreen({super.key});

  @override
  State<AttractionsScreen> createState() {
    return _AttractionsScreenState();
  }
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  List<dynamic> _attractions = [];
  List<dynamic> _favoriteAttractions = []; // รายการโปรด
  Set<int> _favoritedIds = Set<int>(); // ใช้เก็บ ID ของรายการโปรด

  @override
  void initState() {
    super.initState();
    _fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await http.get(
        Uri.parse('https://my.api.mockaroo.com/food_name.json?key=4ce583c0'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ตรวจสอบว่า JSON ที่ได้เป็น List หรือไม่
        if (data is List) {
          setState(() {
            _attractions = data;
          });
        } else {
          throw Exception('Unexpected JSON format: expected a List');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching attractions: $e');
    }
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
        return '🍽️';
    }
  }

  void _toggleFavorite(dynamic attraction) {
    setState(() {
      if (_favoritedIds.contains(attraction['id'])) {
        _favoritedIds.remove(attraction['id']);
        _favoriteAttractions
            .removeWhere((item) => item['id'] == attraction['id']);
      } else {
        _favoritedIds.add(attraction['id']);
        _favoriteAttractions.add(attraction);
      }
    });
  }

  void _deleteFromFavorites(dynamic attraction) {
    setState(() {
      _favoritedIds.remove(attraction['id']);
      _favoriteAttractions
          .removeWhere((item) => item['id'] == attraction['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommand Food'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    favorites: _favoriteAttractions,
                    onFavoriteToggle: _toggleFavorite,
                    onDelete: _deleteFromFavorites,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _attractions.length,
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          bool isFavorited = _favoritedIds.contains(attraction['id']);

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
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : null,
              ),
              onPressed: () => _toggleFavorite(attraction),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AttractionDetailScreen(id: attraction['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
