import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/tafsir_data.dart';

class PlayerScreen extends StatefulWidget {
  final TafsirModel lesson;
  const PlayerScreen({super.key, required this.lesson});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setAsset('assets/${widget.lesson.audioPath}');
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_note, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          Text(widget.lesson.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 64,
                icon: StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return Icon(playing ? Icons.pause_circle : Icons.play_circle);
                  },
                ),
                onPressed: () {
                  if (_player.playing) { _player.pause(); } else { _player.play(); }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
