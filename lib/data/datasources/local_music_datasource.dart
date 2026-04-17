import 'dart:io';
import 'package:path/path.dart' as p;
import '../../domain/entities/track.dart';

class LocalMusicDatasource {
  Future<List<Track>> scanDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }

    final tracks = <Track>[];
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && _isAudioFile(entity.path)) {
        final track = await _fileToTrack(entity);
        if (track != null) {
          tracks.add(track);
        }
      }
    }
    return tracks;
  }

  bool _isAudioFile(String path) {
    final extension = p.extension(path).toLowerCase();
    return ['.mp3', '.m4a', '.wav', '.aac', '.flac'].contains(extension);
  }

  Future<Track?> _fileToTrack(File file) async {
    final fileName = p.basenameWithoutExtension(file.path);
    final parts = fileName.split(' - ');
    
    String title = fileName;
    String artist = 'Unknown Artist';

    if (parts.length >= 2) {
      artist = parts[0].trim();
      title = parts.sublist(1).join(' - ').trim();
    }

    return Track(
      id: file.path.hashCode.toString(),
      title: title,
      artist: artist,
      filePath: file.path,
      duration: Duration.zero,
    );
  }
}