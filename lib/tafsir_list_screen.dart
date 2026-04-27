import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'player_screen.dart';

class TafsirListScreen extends StatelessWidget {
  final bool isTafsir;
  const TafsirListScreen({super.key, required this.isTafsir});

  @override
  Widget build(BuildContext context) {
    final list = isTafsir ? AppData.tafsirList : AppData.muhadaroriList;
    return Scaffold(
      appBar: AppBar(title: Text(isTafsir ? "Tafsir" : "Muhadarori")),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: const Icon(Icons.play_arrow),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerScreen(
                  model: item,          // Current item
                  playlist: list,       // The whole list for Next/Back
                  currentIndex: index,  // Position in the list
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
