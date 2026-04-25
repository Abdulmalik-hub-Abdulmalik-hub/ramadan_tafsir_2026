import 'package:flutter/material.dart';
import 'tafsir_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ramadan Tafsir 2026")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/sheikh.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Sheikh Muhammad Sani Abdullahi Aja",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TafsirListScreen()),
                );
              },
              child: const Text("View All Lessons"),
            ),
          ],
        ),
      ),
    );
  }
}
