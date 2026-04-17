class Track {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration duration;
  final String? albumArt;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
    this.albumArt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Track &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          artist == other.artist &&
          filePath == other.filePath &&
          duration == other.duration &&
          albumArt == other.albumArt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      artist.hashCode ^
      filePath.hashCode ^
      duration.hashCode ^
      albumArt.hashCode;
}

class Playlist {
  final String id;
  final String name;
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.name,
    required this.tracks,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Playlist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}