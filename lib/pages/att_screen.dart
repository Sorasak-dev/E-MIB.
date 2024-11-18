import 'dart:convert';
import 'package:emib_hospital/pages/FavoriteFoodPage.dart';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/att_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttractionsScreen extends StatefulWidget {
  const AttractionsScreen({super.key});

  @override
  State<AttractionsScreen> createState() {
    return _AttractionsScreenState();
  }
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  List<dynamic> _attractions = [];
  List<dynamic> _favoriteAttractions = [];
  Set<int> _favoritedIds = Set<int>();

  @override
  void initState() {
    super.initState();
    _loadFavorites().then((_) {
      _fetchAttractions();
    });
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await http.get(
        Uri.parse('https://my.api.mockaroo.com/f.json?key=f3d1ec70'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            _attractions = data;

            // ตรวจสอบว่ารายการโปรดยังคงอยู่ในข้อมูลที่โหลดจาก API
            _favoriteAttractions = _favoriteAttractions
                .where((item) => _attractions
                    .any((attraction) => attraction['id'] == item['id']))
                .toList();

            _favoritedIds = _favoriteAttractions
                .map<int>((item) => item['id'] as int)
                .toSet();
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

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData =
        _favoriteAttractions.map((e) => json.encode(e)).toList();
    await prefs.setStringList('favoriteFoods', favoriteData);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getStringList('favoriteFoods') ?? [];
    final loadedFavorites =
        favoriteData.map((e) => json.decode(e)).toList(); // โหลดข้อมูลโปรด

    setState(() {
      _favoriteAttractions = loadedFavorites;

      // อัปเดต Set ของ ID
      _favoritedIds =
          _favoriteAttractions.map<int>((item) => item['id'] as int).toSet();
    });
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
      _saveFavorites(); // บันทึกข้อมูลทุกครั้งที่เปลี่ยนแปลง
    });
  }

  void _deleteFromFavorites(dynamic attraction) {
    setState(() {
      _favoritedIds.remove(attraction['id']);
      _favoriteAttractions
          .removeWhere((item) => item['id'] == attraction['id']);
      _saveFavorites(); // บันทึกข้อมูลหลังการลบ
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
                  builder: (context) => FavoriteFoodPage(
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
}
