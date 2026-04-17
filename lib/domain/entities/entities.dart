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
}