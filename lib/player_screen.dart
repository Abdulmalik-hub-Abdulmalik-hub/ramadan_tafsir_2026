import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'data/app_data.dart';

class PlayerScreen extends StatefulWidget {
  final TafsirModel item;
  const PlayerScreen({super.key, required this.item});
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playing")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.item.imagePath, height: 200),
            const SizedBox(height: 20),
            Text(widget.item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            IconButton(
              iconSize: 80,
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: Colors.green),
              onPressed: () async {
                if (isPlaying) {
                  await _audioPlayer.pause();
                } else {
                  await _audioPlayer.play(AssetSource(widget.item.audioPath));
                }
                setState(() => isPlaying = !isPlaying);
              },
            ),
          ],
        ),
      ),
    );
  }
}
