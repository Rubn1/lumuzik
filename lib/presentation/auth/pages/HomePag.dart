import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage%20.dart';
// import 'package:lumuzik/presentation/auth/pages/MusicPlayerPage.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentTabIndex = 0;
  bool _hasPermission = false;

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

    return ListView.builder(
      itemCount: musicFilePaths.length,
      itemBuilder: (context, index) {
        final File musicFile = File(musicFilePaths[index]);
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
            title: Text(musicFile.path.split('/').last),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerPage(
                    musicFilePaths: musicFilePaths,
                    initialIndex: index,
                  ),
                ),
              );
            },
          ),
        );
      },
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
    return const Center(
      child: Text('Pas de playlists pour le moment'),
    );
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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
