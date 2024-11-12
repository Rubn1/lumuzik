import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _currentSongPath;
  bool _showMiniPlayer = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  String? get currentSongPath => _currentSongPath;
  bool get showMiniPlayer => _showMiniPlayer;

  PlayerProvider() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> playFile(String filePath, {bool showMini = true}) async {
    _currentSongPath = filePath;
    _showMiniPlayer = showMini;
    await _audioPlayer.setFilePath(filePath);
    await _audioPlayer.play();
    notifyListeners();
  }

  void togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void toggleMiniPlayer(bool show) {
    _showMiniPlayer = show;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}