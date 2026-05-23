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

class _PlayerScreenState extends State<PlayerScreen> with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isDownloading = false;
  bool isLocalFile = false;
  double downloadProgress = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;
  late AnimationController _playPauseController;
  late Animation<double> _playPauseAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.currentIndex;
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _playPauseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _playPauseController, curve: Curves.easeOut),
    );
    _setupAudioListeners();
    _playAudio();
  }

  void _setupAudioListeners() {
    _audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing) {
          _playPauseController.forward();
        } else {
          _playPauseController.reverse();
        }
      });
    });
  }

  Future<void> _playAudio() async {
    final currentModel = widget.playlist[currentIndex];
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File("${directory.path}/${currentModel.fileName}");
    isLocalFile = await localFile.exists();

    if (isLocalFile) {
      await _audioPlayer.play(DeviceFileSource(localFile.path));
    } else {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (mounted) {
          _showSnackBar("Internet Required for Streaming");
        }
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
          if (total != -1 && mounted) {
            setState(() => downloadProgress = received / total);
          }
        },
      );
      if (mounted) {
        _showSnackBar("Download Complete");
        setState(() => isLocalFile = true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Download Failed");
      }
    } finally {
      if (mounted) {
        setState(() => isDownloading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _next() {
    if (currentIndex < widget.playlist.length - 1) {
      setState(() => currentIndex++);
      _playAudio();
    }
  }

  void _previous() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _playAudio();
    }
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentModel = widget.playlist[currentIndex];
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2F1A), Color(0xFF0A0A0F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isLocalFile
                            ? const Color(0xFF2E7D32).withOpacity(0.8)
                            : Colors.orange.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLocalFile ? Icons.download_done_rounded : Icons.cloud_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isLocalFile ? 'Offline' : 'Streaming',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isDownloading)
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            value: downloadProgress,
                            color: const Color(0xFF2E7D32),
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: _downloadAudio,
                        icon: const Icon(Icons.download_for_offline_rounded, color: Colors.white70),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              // Album Art with glow effect
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withOpacity(0.4),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        currentModel.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Icon(Icons.music_note, size: 80, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Track Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      currentModel.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentModel.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          height: 4,
                          width: MediaQuery.of(context).size.width - 64 * progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF81C784)]),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(position),
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        ),
                        Text(
                          _formatTime(duration),
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previous,
                    icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 24),
                  ScaleTransition(
                    scale: _playPauseAnimation,
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2E7D32).withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: _next,
                    icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                  ),
                ],
              ),

              const Spacer(),

              // Bottom info
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.queue_music_rounded, size: 16, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(width: 8),
                    Text(
                      '${currentIndex + 1} of ${widget.playlist.length}',
                      style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
