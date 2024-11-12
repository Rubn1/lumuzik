import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final List<String> musicFilePaths;
  final int currentIndex;
  final VoidCallback onExpand;

  const MiniPlayer({
    Key? key,
    required this.audioPlayer,
    required this.musicFilePaths,
    required this.currentIndex,
    required this.onExpand,
  }) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  String _getFileName() {
    final file = File(widget.musicFilePaths[widget.currentIndex]);
    return file.path.split('/').last.replaceAll('.mp3', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre de la chanson
          Text(
            _getFileName(),
            style: TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          // Boutons de contrôle
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  if (widget.currentIndex > 0) {
                    widget.audioPlayer.setFilePath(
                      widget.musicFilePaths[widget.currentIndex - 1],
                    );
                  }
                },
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
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  if (widget.currentIndex < widget.musicFilePaths.length - 1) {
                    widget.audioPlayer.setFilePath(
                      widget.musicFilePaths[widget.currentIndex + 1],
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
