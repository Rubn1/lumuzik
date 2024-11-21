import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lumuzik/presentation/auth/pages/player_provider.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final List<String> musicFilePaths;
  final int currentIndex;
  final VoidCallback onExpand;

  const MiniPlayer({
    super.key,
    required this.audioPlayer,
    required this.musicFilePaths,
    required this.currentIndex,
    required this.onExpand,
  });

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}
class _MiniPlayerState extends State<MiniPlayer> {
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    widget.audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    widget.audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    });
  }
  String _getFileName() {
    final file = File(widget.musicFilePaths[widget.currentIndex]);
    return file.path.split('/').last.replaceAll('.mp3', '');
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    
    return GestureDetector(
      onTap: widget.onExpand,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: _duration.inSeconds > 0 
                ? _position.inSeconds / _duration.inSeconds 
                : 0,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 2,
            ),
            // Player controls
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // Album art placeholder
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white54),
                    ),
                    const SizedBox(width: 12),
                    // Song info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getFileName(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Unknown Artist', // You can add metadata reading later
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Playback controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: widget.currentIndex > 0
                              ? () async {
                                  await widget.audioPlayer.setFilePath(
                                    widget.musicFilePaths[widget.currentIndex - 1],
                                  );
                                  await widget.audioPlayer.play();
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _isPlaying
                                ? widget.audioPlayer.pause()
                                : widget.audioPlayer.play();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: widget.currentIndex < widget.musicFilePaths.length - 1
                              ? () async {
                                  await widget.audioPlayer.setFilePath(
                                    widget.musicFilePaths[widget.currentIndex + 1],
                                  );
                                  await widget.audioPlayer.play();
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
//lafinnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn