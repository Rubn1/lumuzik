import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lumuzik/presentation/auth/pages/MiniPlayer.dart';
import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage .dart';
import 'package:lumuzik/presentation/auth/pages/playlistPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({Key? key}) : super(key: key);

  @override
  _MusicLibraryPageState createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage> {
  List<String> musicFilePaths = [];
  List<String> selectedMusicPaths = [];
  bool isSelectionMode = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentTabIndex = 0;
  bool _hasPermission = false;
  bool _showMiniPlayer = false;
  int _currentMusicIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAndLoadMusicFiles();
  }

  Future<void> _checkAndLoadMusicFiles() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      await _loadSavedMusicFiles();
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _hasPermission = true;
        });
        await _loadSavedMusicFiles();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission refusée. Impossible d\'accéder aux fichiers musicaux.')),
        );
      }
    }
  }

  Future<void> _loadSavedMusicFiles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      musicFilePaths = prefs.getStringList('musicFiles') ?? [];
    });
  }

  void _toggleMusicSelection(String path) {
    setState(() {
      if (selectedMusicPaths.contains(path)) {
        selectedMusicPaths.remove(path);
      } else {
        selectedMusicPaths.add(path);
      }
    });
  }

  Future<void> _createPlaylist() async {
    if (selectedMusicPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez au moins un morceau')),
      );
      return;
    }

    final nameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom de la playlist',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('Créer'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final playlist = Playlist(
        name: result,
        musicPaths: List.from(selectedMusicPaths),
      );

      final prefs = await SharedPreferences.getInstance();
      final playlistsJson = prefs.getStringList('playlists') ?? [];
      playlistsJson.add(jsonEncode(playlist.toJson()));
      await prefs.setStringList('playlists', playlistsJson);

      setState(() {
        isSelectionMode = false;
        selectedMusicPaths.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playlist "${playlist.name}" créée')),
      );
    }
  }

  Future<void> _addMusicFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac'],
      allowMultiple: true,
    );

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      final newPaths = result.paths
          .whereType<String>()
          .where((path) => !musicFilePaths.contains(path))
          .toList();

      setState(() {
        musicFilePaths.addAll(newPaths);
      });

      await prefs.setStringList('musicFiles', musicFilePaths);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun fichier musical sélectionné.')),
      );
    }
  }

  Future<void> _removeMusic(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      musicFilePaths.removeAt(index);
    });
    await prefs.setStringList('musicFiles', musicFilePaths);
  }

  void _openMusicPlayer(int index) {
    setState(() {
      _currentMusicIndex = index;
      _showMiniPlayer = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(
          musicFilePaths: musicFilePaths,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildMusicList() {
    if (musicFilePaths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Aucun fichier musical trouvé.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMusicFiles,
              child: const Text('Ajouter des fichiers musicaux'),
            )
          ],
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: musicFilePaths.length,
          itemBuilder: (context, index) {
            final File musicFile = File(musicFilePaths[index]);
            final bool isSelected = selectedMusicPaths.contains(musicFilePaths[index]);
            
            return Dismissible(
              key: Key(musicFilePaths[index]),
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                _removeMusic(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${musicFile.path.split('/').last} supprimé')),
                );
              },
              child: ListTile(
                leading: isSelectionMode 
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (_) => _toggleMusicSelection(musicFilePaths[index]),
                    )
                  : const Icon(Icons.music_note),
                title: Text(musicFile.path.split('/').last),
                onTap: isSelectionMode
                  ? () => _toggleMusicSelection(musicFilePaths[index])
                  : () => _openMusicPlayer(index),
                onLongPress: () {
                  setState(() {
                    isSelectionMode = true;
                    selectedMusicPaths.add(musicFilePaths[index]);
                  });
                },
              ),
            );
          },
        ),
        if (isSelectionMode)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: _createPlaylist,
              label: const Text('Créer une playlist'),
              icon: const Icon(Icons.playlist_add),
            ),
          ),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: _currentTabIndex == index ? Colors.blue : Colors.grey,
      ),
      child: Text(title),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildMusicList();
      case 1:
        return _buildPlaylistsView();
      case 2:
        return _buildArtistsView();
      case 3:
        return _buildAlbumsView();
      default:
        return Container();
    }
  }

  Widget _buildPlaylistsView() {
  return const PlaylistPage();
}

  Widget _buildArtistsView() {
    return const Center(
      child: Text('Aucun artiste trouvé'),
    );
  }

  Widget _buildAlbumsView() {
    return const Center(
      child: Text('Aucun album trouvé'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumuzik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMusicFiles,
          ),
        ],
      ),
      body: _hasPermission
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton('Chansons', 0),
                    _buildTabButton('Playlists', 1),
                    _buildTabButton('Artistes', 2),
                    _buildTabButton('Albums', 3),
                  ],
                ),
                Expanded(
                  child: _buildTabContent(),
                ),
                if (_showMiniPlayer)
                  MiniPlayer(
                    audioPlayer: _audioPlayer,
                    musicFilePaths: musicFilePaths,
                    currentIndex: _currentMusicIndex,
                    onExpand: () {
                      _openMusicPlayer(_currentMusicIndex);
                    },
                  ),
              ],
            )
          : Center(
              child: ElevatedButton(
                child: const Text('Autoriser l\'accès aux fichiers'),
                onPressed: _checkAndLoadMusicFiles,
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

// Classe Playlist pour la sérialisation
class Playlist {
  final String name;
  final List<String> musicPaths;

  Playlist({
    required this.name,
    required this.musicPaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'musicPaths': musicPaths,
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      name: json['name'],
      musicPaths: List<String>.from(json['musicPaths']),
    );
  }
  
}