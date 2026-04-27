import 'package:flutter/material.dart';
import 'tafsir_list_screen.dart';

void main() {
  runApp(const RamadanApp());
}

class RamadanApp extends StatelessWidget {
  const RamadanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramadan Tafsir 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sheikh.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay to make text readable
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  "RAMADAN TAFSIR 2026", 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const Spacer(),
                _buildMenuButton(context, "TAFSIRIN RAMADAN", Icons.menu_book, true),
                const SizedBox(height: 20),
                _buildMenuButton(context, "MUHADARORI", Icons.mic, false),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, bool isTafsir) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white, // Text and Icon color
        ),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => TafsirListScreen(isTafsir: isTafsir)
            ),
          );
        },
        icon: Icon(icon),
        label: Text(
          text, 
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
