class Track {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String filePath;
  final Duration duration;
  final String? albumArt;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
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
          album == other.album &&
          filePath == other.filePath &&
          duration == other.duration &&
          albumArt == other.albumArt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      artist.hashCode ^
      album.hashCode ^
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

  int get trackCount => tracks.length;

  Duration get totalDuration {
    return tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );
  }

  Playlist addTrack(Track track) {
    return Playlist(
      id: id,
      name: name,
      tracks: [...tracks, track],
    );
  }

  Playlist removeTrack(String trackId) {
    return Playlist(
      id: id,
      name: name,
      tracks: tracks.where((t) => t.id != trackId).toList(),
    );
  }

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