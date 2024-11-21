import 'package:flutter/material.dart';
import 'package:lumuzik/presentation/auth/pages/player_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumuzik/presentation/auth/models/playlist.dart';
import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage .dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playlistsJson = prefs.getStringList('playlists') ?? [];
      setState(() {
        playlists = playlistsJson
            .map((json) => Playlist.fromJson(jsonDecode(json)))
            .toList();
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des playlists: $e');
    }
  }

  Future<void> _deletePlaylist(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playlistsJson = prefs.getStringList('playlists') ?? [];
      playlistsJson.removeAt(index);
      await prefs.setStringList('playlists', playlistsJson);
      await _loadPlaylists();
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la playlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_play, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune playlist trouvée',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Créez une playlist en sélectionnant des morceaux',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return Dismissible(
          key: Key(playlist.name + index.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _deletePlaylist(index),
          child: ListTile(
            leading: const Icon(Icons.playlist_play),
            title: Text(playlist.name),
            subtitle: Text('${playlist.musicPaths.length} morceaux'),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerPage(
                    musicFilePaths: playlist.musicPaths,
                    initialIndex: index,
                    playerProvider: Provider.of<PlayerProvider>(context, listen: false),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
//la finnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn