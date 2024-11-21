import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lumuzik/presentation/auth/pages/statistics.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _currentSongPath;
  List<String> _playlistPaths = [];
  int _currentIndex = 0;
  bool _showMiniPlayer = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  String? get currentSongPath => _currentSongPath;
  bool get showMiniPlayer => _showMiniPlayer;
  List<String> get playlistPaths => _playlistPaths;
  int get currentIndex => _currentIndex;

  PlayerProvider() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      
      if(state.processingState == ProcessingState.completed) {
        _updateStatistics();
      }
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

    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState != null) {
        _currentIndex = sequenceState.currentIndex;
        _currentSongPath = _playlistPaths[_currentIndex];
        notifyListeners();
      }
    });
  }

  Future<void> setPlaylist(List<String> paths, {int initialIndex = 0}) async {
    _playlistPaths = paths;
    _currentIndex = initialIndex;

    final playlist = ConcatenatingAudioSource(
      children: paths.map((path) => AudioSource.uri(Uri.file(path))).toList(),
    );

    await _audioPlayer.setAudioSource(playlist, initialIndex: initialIndex);
    _currentSongPath = paths[initialIndex];
    _showMiniPlayer = true;
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> playFile(String filePath, {bool showMini = true, List<String>? playlist}) async {
    if (playlist != null) {
      await setPlaylist(playlist, initialIndex: playlist.indexOf(filePath));
    } else {
      _currentSongPath = filePath;
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    }
    _showMiniPlayer = showMini;
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void toggleMiniPlayer(bool show) {
    _showMiniPlayer = show;
    notifyListeners();
  }

  void playNext() {
    _updateStatistics();
    if (_currentIndex < _playlistPaths.length - 1) {
      _audioPlayer.seekToNext();
    }
  }

  void playPrevious() {
    _updateStatistics();
    if (_currentIndex > 0) {
      _audioPlayer.seekToPrevious();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void pauseOrContinue() {
    _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
  }
  
  Future<void> _updateStatistics() async{
  if (currentSongPath != null && _duration != Duration.zero) {
    if(position > const Duration(seconds: 10)) {
      await StatisticsProvider.recordListeningEvent(
        currentSongPath!,
        position
      );
      
    }
    StatisticsProvider.recordListeningEvent(
      currentSongPath!, 
      // Use the total time the song was played
      position 
    );
  }
}
}