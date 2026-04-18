import 'package:audiotags/audiotags.dart';
import 'package:path/path.dart' as p;

class MetadataExtractor {
  Future<TrackMetadata> extractMetadata(String filePath) async {
    try {
      final tag = await AudioTags.read(filePath);
      
      if (tag == null) {
        return _parseFromFilename(filePath);
      }
      
      return TrackMetadata(
        title: tag.title ?? p.basenameWithoutExtension(filePath),
        artist: tag.trackArtist ?? 'Unknown Artist',
        album: tag.album,
        duration: Duration(milliseconds: tag.duration ?? 0),
        albumArt: null,
      );
    } catch (e) {
      return _parseFromFilename(filePath);
    }
  }

  TrackMetadata _parseFromFilename(String filePath) {
    final fileName = p.basenameWithoutExtension(filePath);
    final parts = fileName.split(' - ');
    
    return TrackMetadata(
      title: parts.length >= 2 ? parts.sublist(1).join(' - ').trim() : fileName,
      artist: parts.length >= 2 ? parts[0].trim() : 'Unknown Artist',
      album: null,
      duration: Duration.zero,
      albumArt: null,
    );
  }
}

class TrackMetadata {
  final String title;
  final String artist;
  final String? album;
  final Duration duration;
  final List<int>? albumArt;

  TrackMetadata({
    required this.title,
    required this.artist,
    this.album,
    required this.duration,
    this.albumArt,
  });
}