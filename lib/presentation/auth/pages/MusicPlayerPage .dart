import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumuzik/presentation/auth/pages/player_provider.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<String> musicFilePaths;
  final int initialIndex;
  final PlayerProvider playerProvider;

  const MusicPlayerPage({
    super.key, 
    required this.musicFilePaths, 
    required this.initialIndex,
    required this.playerProvider,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      playerProvider.setPlaylist(
        widget.musicFilePaths, 
        initialIndex: widget.initialIndex
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        // Ensure we have a valid current song path
        if (playerProvider.currentSongPath == null || playerProvider.currentSongPath!.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final File musicFile = File(playerProvider.currentSongPath!);
        final String musicTitle = musicFile.path.split('/').last.replaceAll('.mp3', '');

        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            title: const Text('Now Playing'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Album Art Placeholder
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade800,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      size: 120,
                      color: Colors.white54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Song Title
                Text(
                  musicTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Slider with Duration
                Row(
                  children: [
                    Text(
                      _formatDuration(playerProvider.position),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white30,
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withAlpha(50),
                        ),
                        child: Slider(
                          value: playerProvider.position.inSeconds.toDouble(),
                          max: playerProvider.duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            playerProvider.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(playerProvider.duration),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous Button
                    _PlayerIconButton(
                      icon: Icons.skip_previous,
                      onPressed: playerProvider.currentIndex > 0 
                        ? () {
                            playerProvider.playPrevious();
                            setState(() {}); // Force rebuild to update UI
                          }
                        : null,
                    ),
                    
                    // Play/Pause Button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 64,
                        color: Colors.white,
                        icon: Icon(playerProvider.isPlaying 
                          ? Icons.pause_circle_filled 
                          : Icons.play_circle_filled),
                        onPressed: playerProvider.togglePlay,
                      ),
                    ),
                    
                    // Next Button
                    _PlayerIconButton(
                      icon: Icons.skip_next,
                      onPressed: playerProvider.currentIndex < playerProvider.playlistPaths.length - 1 
                        ? () {
                            playerProvider.playNext();
                            setState(() {}); // Force rebuild to update UI
                          }
                        : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Icon Button with a subtle hover effect
class _PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PlayerIconButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      color: onPressed != null ? Colors.white : Colors.white38,
      icon: Icon(icon),
      onPressed: onPressed,
      splashColor: Colors.white24,
      highlightColor: Colors.white12,
    );
  }
}