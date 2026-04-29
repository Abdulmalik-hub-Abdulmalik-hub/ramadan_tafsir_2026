import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'screens/player_screen.dart';

class TafsirListScreen extends StatelessWidget {
  final bool isTafsir;
  const TafsirListScreen({super.key, required this.isTafsir});

  @override
  Widget build(BuildContext context) {
    final list = isTafsir ? AppData.tafsirList : AppData.muhadaroriList;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: Text(isTafsir ? "Tafsir" : "Muhadarori"),
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Card(
            color: const Color(0xFF1A1A2E),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(item.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.cloud_outlined, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text("Internet Required", style: TextStyle(color: Colors.green.shade400, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              trailing: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 18,
                child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    model: item,
                    playlist: list,
                    currentIndex: index,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
