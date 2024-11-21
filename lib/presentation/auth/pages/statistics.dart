import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Enhanced ListeningStatistics with more metadata
class ListeningStatistics {
  final String songPath;
  final String artist;
  final String album;
  int playCount;
  Duration totalListeningTime;
  DateTime lastPlayed;

  ListeningStatistics({
    required this.songPath,
    this.artist = 'Unknown Artist',
    this.album = 'Unknown Album',
    this.playCount = 0,
    this.totalListeningTime = Duration.zero,
    DateTime? lastPlayed,
  }) : lastPlayed = lastPlayed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'songPath': songPath,
    'artist': artist,
    'album': album,
    'playCount': playCount,
    'totalListeningTime': totalListeningTime.inSeconds,
    'lastPlayed': lastPlayed.toIso8601String(),
  };

  factory ListeningStatistics.fromJson(Map<String, dynamic> json) => ListeningStatistics(
    songPath: json['songPath'],
    artist: json['artist'] ?? 'Unknown Artist',
    album: json['album'] ?? 'Unknown Album',
    playCount: json['playCount'],
    totalListeningTime: Duration(seconds: json['totalListeningTime']),
    lastPlayed: DateTime.parse(json['lastPlayed'] ?? DateTime.now().toIso8601String()),
  );
}

// More robust statistics provider
class StatisticsProvider {
  static const _statisticsKey = 'listening_statistics';

  static Future<void> recordListeningEvent(
    String songPath, 
    Duration listeningTime, {
    String? artist,
    String? album,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final statisticsJson = prefs.getStringList(_statisticsKey) ?? [];

    final statistics = statisticsJson.map((json) => 
      ListeningStatistics.fromJson(jsonDecode(json))
    ).toList();

    final existingStatIndex = statistics.indexWhere(
      (stat) => stat.songPath == songPath
    );

    if (existingStatIndex != -1) {
      statistics[existingStatIndex]
    ..playCount += 1
    ..totalListeningTime += listeningTime
    ..lastPlayed = DateTime.now();
    } else {
      statistics.add(ListeningStatistics(
        songPath: songPath, 
        playCount: 1, 
        totalListeningTime: listeningTime,
        artist: artist ?? 'Unknown Artist',
        album: album ?? 'Unknown Album',
      ));
    }

    await prefs.setStringList(
      _statisticsKey, 
      statistics.map((stat) => jsonEncode(stat.toJson())).toList()
    );
  }

  static Future<List<ListeningStatistics>> getTopSongs({
    int limit = 10, 
    StatsSortType sortType = StatsSortType.playCount
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final statisticsJson = prefs.getStringList(_statisticsKey) ?? [];

    final statistics = statisticsJson.map((json) => 
      ListeningStatistics.fromJson(jsonDecode(json))
    ).toList();

    switch (sortType) {
      case StatsSortType.playCount:
        statistics.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case StatsSortType.listeningTime:
        statistics.sort((a, b) => b.totalListeningTime.compareTo(a.totalListeningTime));
        break;
      case StatsSortType.recentlyPlayed:
        statistics.sort((a, b) => b.lastPlayed.compareTo(a.lastPlayed));
        break;
    }

    return statistics.take(limit).toList();
  }

  static Future<Duration> getTotalListeningTime() async {
    final prefs = await SharedPreferences.getInstance();
    final statisticsJson = prefs.getStringList(_statisticsKey) ?? [];

    final statistics = statisticsJson.map((json) => 
      ListeningStatistics.fromJson(jsonDecode(json))
    ).toList();

    return statistics.fold(
      Duration.zero, 
      (total, stat) => stat.totalListeningTime
    );
  }
}

enum StatsSortType { playCount, listeningTime, recentlyPlayed }

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<ListeningStatistics> _topSongs = [];
  Duration _totalListeningTime = Duration.zero;
  StatsSortType _currentSortType = StatsSortType.playCount;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final topSongs = await StatisticsProvider.getTopSongs(
      sortType: _currentSortType
    );
    final totalTime = await StatisticsProvider.getTotalListeningTime();

    setState(() {
      _topSongs = topSongs;
      _totalListeningTime = totalTime;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) return '${hours}h ${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  String _extractSongName(String path) {
    return path.split('/').last.replaceAll(RegExp(r'\.(mp3|wav|aac)$'), '');
  }

  void _changeSortType(StatsSortType sortType) {
    setState(() {
      _currentSortType = sortType;
      _loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Statistics'),
        actions: [
          PopupMenuButton<StatsSortType>(
            icon: const Icon(Icons.sort),
            onSelected: _changeSortType,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: StatsSortType.playCount,
                child: Text('Sort by Play Count'),
              ),
              const PopupMenuItem(
                value: StatsSortType.listeningTime,
                child: Text('Sort by Listening Time'),
              ),
              const PopupMenuItem(
                value: StatsSortType.recentlyPlayed,
                child: Text('Sort by Recently Played'),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Total Listening Time Card with improved design
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.white, size: 36),
                title: Text(
                  'Total Listening Time', 
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _formatDuration(_totalListeningTime),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Top Songs Section with improved design
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Songs',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          
          if (_topSongs.isEmpty)
            const Center(
              child: Column(
                children: [
                  Icon(Icons.music_note, size: 60, color: Colors.grey),
                  Text(
                    'No listening statistics yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  )
                ],
              )
            )
          else 
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _topSongs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final song = _topSongs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      '${index + 1}', 
                      style: TextStyle(
                        color: Colors.blue.shade800, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  title: Text(
                    _extractSongName(song.songPath),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(song.artist),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${song.playCount} plays', 
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        _formatDuration(song.totalListeningTime),
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.grey.shade600
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}