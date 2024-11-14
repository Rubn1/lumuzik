import 'dart:io';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<String> musicFilePaths;

  const SearchPage({
    Key? key,
    required this.musicFilePaths,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final List<String> results = widget.musicFilePaths.where((path) {
      final filename = path.split('/').last.toLowerCase();
      final searchLower = query.toLowerCase();
      
      // Recherche dans le nom du fichier (qui contient généralement titre et artiste)
      return filename.contains(searchLower);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Rechercher une musique...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Color.fromARGB(255, 253, 174, 3)),
          onChanged: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: _searchController.text.isEmpty
                  ? const Text('Commencez à taper pour rechercher')
                  : const Text('Aucun résultat trouvé'),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final File musicFile = File(_searchResults[index]);
                final String filename = musicFile.path.split('/').last;

                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(filename),
                  onTap: () {
                    // Trouver l'index de la musique dans la liste originale
                    final originalIndex = widget.musicFilePaths.indexOf(_searchResults[index]);
                    if (originalIndex != -1) {
                      Navigator.pop(context, originalIndex); // Retourner l'index pour la lecture
                    }
                  },
                );
              },
            ),
    );
  }
}