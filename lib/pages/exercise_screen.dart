import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/exercise_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:emib_hospital/pages/favorite_page.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() {
    return _ExerciseScreenState();
  }
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<dynamic> _exercises = [];
  List<dynamic> _favoriteExercise = []; // รายการโปรด
  Set<int> _favoritedIds = Set<int>(); // ใช้เก็บ ID ของรายการโปรด

  @override
  void initState() {
    super.initState();
    _fetchExercise();
  }

  Future<void> _fetchExercise() async {
    final response = await http.get(Uri.parse('https://my.api.mockaroo.com/exercise.json?key=4ce583c0'));
    setState(() {
      _exercises = json.decode(response.body);
    });
  }

  /*String getFoodEmoji(String category) {
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
  }*/

  void _toggleFavorite(dynamic exercise) {
    setState(() {
      if (_favoritedIds.contains(exercise['id'])) {
        _favoritedIds.remove(exercise['id']);
        _favoriteExercise.removeWhere((item) => item['id'] == exercise['id']);
      } else {
        _favoritedIds.add(exercise['id']);
        _favoriteExercise.add(exercise);
      }
    });
  }

  void _deleteFromFavorites(dynamic exercise) {
    setState(() {
      _favoritedIds.remove(exercise['id']);
      _favoriteExercise.removeWhere((item) => item['id'] == exercise['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommand Exercise'),
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
                    onDelete: _deleteFromFavorites,
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
            /*leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Text(
                getFoodEmoji(exercise['food_categoryname'] ?? ''),
                style: const TextStyle(fontSize: 24),
              ),
            ),*/
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
                  builder: (context) => ExerciseDetailScreen(id: exercise['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
