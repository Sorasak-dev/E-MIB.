import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final List<dynamic> favorites;
  final Function(dynamic) onFavoriteToggle;
  final Function(dynamic) onDelete;

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
                final exercise = widget.favorites[index];

                return ListTile(
                  title: Text(exercise['Exercise_Name']),
                  subtitle: Text(
                    'กลุ่มเป้าหมาย: ${exercise['Target Group']}\n${exercise['Description']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onDelete(exercise);
                      setState(() {
                        widget.favorites.remove(exercise);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
