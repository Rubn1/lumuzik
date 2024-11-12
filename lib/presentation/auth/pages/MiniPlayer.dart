import 'package:flutter/material.dart';
import 'package:lumuzik/presentation/auth/pages/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage .dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        if (!playerProvider.showMiniPlayer || playerProvider.currentSongPath == null) {
          return const SizedBox.shrink();
        }

        final songName = playerProvider.currentSongPath!.split('/').last;
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicPlayerPage(
                  musicFilePaths: [playerProvider.currentSongPath!],
                  initialIndex: 0,
                ),
              ),
            );
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        songName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: playerProvider.duration.inSeconds > 0
                            ? playerProvider.position.inSeconds / 
                              playerProvider.duration.inSeconds
                            : 0,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    playerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: playerProvider.togglePlay,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}