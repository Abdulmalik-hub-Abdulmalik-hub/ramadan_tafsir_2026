import 'package:flutter/material.dart';
import '../data/tafsir_data.dart';
import 'player_screen.dart';

class TafsirListScreen extends StatelessWidget {
  const TafsirListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tafsir Lessons")),
      body: ListView.builder(
        itemCount: tafsirList.length,
        itemBuilder: (context, index) {
          final lesson = tafsirList[index];
          return ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.green),
            title: Text(lesson.title),
            subtitle: const Text("Sheikh Muhammad Sani Abdullahi Aja"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(lesson: lesson),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
