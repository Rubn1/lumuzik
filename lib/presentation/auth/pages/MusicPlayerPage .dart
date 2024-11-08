import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<String> musicFilePaths;
  final int initialIndex;

  const MusicPlayerPage({
    Key? key, 
    required this.musicFilePaths, 
    required this.initialIndex
  }) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();
    _loadCurrentSong();
  }

  Future<void> _loadCurrentSong() async {
    try {
      await _audioPlayer.setFilePath(widget.musicFilePaths[_currentIndex]);
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        setState(() {
          _isPlaying = playerState.playing;
        });
      });

      await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing music: $e')),
      );
    }
  }

  void _playNext() {
    if (_currentIndex < widget.musicFilePaths.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _loadCurrentSong();
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _loadCurrentSong();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final File musicFile = File(widget.musicFilePaths[_currentIndex]);
    final String musicTitle = musicFile.path.split('/').last.replaceAll('.mp3', '');

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Now Playing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.music_note,
                  size: 120,
                  color: Colors.white54,
                ),
              ),
            ),
            SizedBox(height: 30),
            
            // Song Title
            Text(
              musicTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),

            // Slider with Duration
            Row(
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(color: Colors.white70),
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
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value) async {
                        await _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(color: Colors.white70),
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
                  onPressed: _playPrevious,
                ),
                
                // Play/Pause Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 64,
                    color: Colors.white,
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                    onPressed: () async {
                      _isPlaying ? await _audioPlayer.pause() : await _audioPlayer.play();
                    },
                  ),
                ),
                
                // Next Button
                _PlayerIconButton(
                  icon: Icons.skip_next,
                  onPressed: _playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

// Custom Icon Button with a subtle hover effect
class _PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _PlayerIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      color: Colors.white,
      icon: Icon(icon),
      onPressed: onPressed,
      splashColor: Colors.white24,
      highlightColor: Colors.white12,
    );
  }
}