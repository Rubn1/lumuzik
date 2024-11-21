

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
      name: json['name'] as String,
      musicPaths: List<String>.from(json['musicPaths'] as List),
    );
  }
}