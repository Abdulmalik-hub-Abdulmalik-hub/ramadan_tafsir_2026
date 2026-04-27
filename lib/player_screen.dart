import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_data.dart';

class PlayerScreen extends StatefulWidget {
  final TafsirModel model;
  final List<TafsirModel> playlist;
  final int currentIndex;

  const PlayerScreen({
    super.key,
    required this.model,
    required this.playlist,
    required this.currentIndex,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.currentIndex;
    _setupAudio();
  }

  void _setupAudio() async {
    _audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
    _playAudio();
  }

  void _playAudio() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(widget.playlist[currentIndex].audioPath));
  }

  void _next() {
    if (currentIndex < widget.playlist.length - 1) {
      setState(() {
        currentIndex++;
        _playAudio();
      });
    }
  }

  void _previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _playAudio();
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentModel = widget.playlist[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Disk Image (Decoration)
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 30)],
                image: DecorationImage(
                  image: AssetImage(currentModel.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            currentModel.title,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            currentModel.subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 30),
          // Slider
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            activeColor: Colors.green,
            inactiveColor: Colors.white24,
            onChanged: (value) async {
              await _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(position), style: const TextStyle(color: Colors.white70)),
                Text(_formatTime(duration), style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white, size: 45),
                onPressed: _previous,
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white, size: 45),
                onPressed: _next,
              ),
            ],
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.redAccent, size: 30),
            onPressed: () => _audioPlayer.stop(),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0").substring(2);
  }
}
