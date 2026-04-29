import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/app_data.dart';

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
  bool isDownloading = false;
  double downloadProgress = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.currentIndex;
    _setupAudioListeners();
    _playAudio();
  }

  void _setupAudioListeners() {
    _audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _playAudio() async {
    final currentModel = widget.playlist[currentIndex];
    
    // Check if file exists locally first (Offline)
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File("${directory.path}/${currentModel.fileName}");

    if (await localFile.exists()) {
      await _audioPlayer.play(DeviceFileSource(localFile.path));
    } else {
      // Check Internet for Streaming
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _showSnackBar("Internet Required for Streaming");
        return;
      }
      await _audioPlayer.play(UrlSource(currentModel.audioUrl));
    }
  }

  Future<void> _downloadAudio() async {
    final currentModel = widget.playlist[currentIndex];
    final directory = await getApplicationDocumentsDirectory();
    final savePath = "${directory.path}/${currentModel.fileName}";

    if (await File(savePath).exists()) {
      _showSnackBar("Already Downloaded");
      return;
    }

    setState(() {
      isDownloading = true;
      downloadProgress = 0;
    });

    try {
      await Dio().download(
        currentModel.audioUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => downloadProgress = received / total);
          }
        },
      );
      _showSnackBar("Download Complete");
    } catch (e) {
      _showSnackBar("Download Failed");
    } finally {
      setState(() => isDownloading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        actions: [
          if (isDownloading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(value: downloadProgress, color: Colors.green),
            )
          else
            IconButton(
              icon: const Icon(Icons.download_for_offline, color: Colors.white),
              onPressed: _downloadAudio,
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_queue, color: Colors.green, size: 16),
              const SizedBox(width: 5),
              Text("Online Streaming Ready", style: TextStyle(color: Colors.green.shade300, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 40)],
                image: DecorationImage(image: AssetImage(currentModel.imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(currentModel.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(currentModel.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 40),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
            activeColor: Colors.green,
            onChanged: (value) async => await _audioPlayer.seek(Duration(seconds: value.toInt())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(position), style: const TextStyle(color: Colors.white60)),
                Text(_formatTime(duration), style: const TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40), onPressed: _previous),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => isPlaying ? _audioPlayer.pause() : _audioPlayer.resume(),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 40), onPressed: _next),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration d) => d.toString().split('.').first.padLeft(8, "0").substring(2);
}
