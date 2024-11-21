import 'package:flutter/material.dart';
import 'package:lumuzik/presentation/auth/models/playlist.dart';
import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage%20.dart';
// import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage.dart';
import 'package:lumuzik/presentation/auth/pages/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlaylistDetailsPage extends StatefulWidget {
  final Playlist playlist;
  final int playlistIndex;

  const PlaylistDetailsPage({
    Key? key, 
    required this.playlist, 
    required this.playlistIndex
  }) : super(key: key);

  @override
  _PlaylistDetailsPageState createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  late List<String> musicPaths;

  @override
  void initState() {
    super.initState();
    musicPaths = widget.playlist.musicPaths;
  }

  Future<void> _removeSongFromPlaylist(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playlistsJson = prefs.getStringList('playlists') ?? [];
      
      // Remove the song from the current playlist
      musicPaths.removeAt(index);
      
      // Update the playlist in SharedPreferences
      final updatedPlaylists = playlistsJson.map((playlistJson) {
        final playlist = Playlist.fromJson(jsonDecode(playlistJson));
        if (playlist.name == widget.playlist.name) {
          return jsonEncode(Playlist(
            name: playlist.name, 
            musicPaths: musicPaths
          ).toJson());
        }
        return playlistJson;
      }).toList();

      await prefs.setStringList('playlists', updatedPlaylists);
      
      setState(() {});
    } catch (e) {
      debugPrint('Erreur lors de la suppression du morceau: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (musicPaths.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.playlist.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.music_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Aucun morceau dans ${widget.playlist.name}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ajoutez des morceaux à votre playlist',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
      ),
      body: ListView.builder(
        itemCount: musicPaths.length,
        itemBuilder: (context, index) {
          final musicPath = musicPaths[index];
          return Dismissible(
            key: Key(musicPath),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _removeSongFromPlaylist(index),
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(musicPath.split('/').last),
              trailing: const Icon(Icons.play_arrow),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicPlayerPage(
                      musicFilePaths: musicPaths,
                      initialIndex: index,
                      playerProvider: Provider.of<PlayerProvider>(context, listen: false),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}