import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/exercise_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:emib_hospital/pages/favorite_page.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() {
    return _ExerciseScreenState();
  }
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<dynamic> _exercises = [];
  List<dynamic> _favoriteExercise = [];
  Set<int> _favoritedIds = Set<int>();

  @override
  void initState() {
    super.initState();
    _fetchExercise();
    _loadFavorites(); // โหลดข้อมูลรายการโปรดเมื่อเริ่มแอป
  }

  Future<void> _fetchExercise() async {
    try {
      final response = await http.get(
        Uri.parse('https://my.api.mockaroo.com/exercise.json?key=8b86cc20'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _exercises = data;
          });
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = _favoriteExercise.map((e) => json.encode(e)).toList();
    await prefs.setStringList('favoriteExercises', favoriteData);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getStringList('favoriteExercises') ?? [];
    setState(() {
      _favoriteExercise = favoriteData.map((e) => json.decode(e)).toList();
      _favoritedIds = _favoriteExercise
          .map<int>((item) => item['id'] as int)
          .toSet(); // อัปเดต ID ของรายการโปรด
    });
  }

  void _toggleFavorite(dynamic exercise) {
    setState(() {
      if (_favoritedIds.contains(exercise['id'])) {
        _favoritedIds.remove(exercise['id']);
        _favoriteExercise.removeWhere((item) => item['id'] == exercise['id']);
      } else {
        _favoritedIds.add(exercise['id']);
        _favoriteExercise.add(exercise);
      }
      _saveFavorites(); // บันทึกข้อมูลเมื่อมีการเปลี่ยนแปลง
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommend Exercise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    favorites: _favoriteExercise,
                    onFavoriteToggle: _toggleFavorite,
                    onDelete: (exercise) {
                      setState(() {
                        _toggleFavorite(exercise);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          bool isFavorited = _favoritedIds.contains(exercise['id']);

          return ListTile(
            title: Text(exercise['Exercise_Name']),
            subtitle: Text(
              'กลุ่มเป้าหมาย: ${exercise['Target Group']}\n${exercise['Description']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : null,
              ),
              onPressed: () => _toggleFavorite(exercise),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ExerciseDetailScreen(id: exercise['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
