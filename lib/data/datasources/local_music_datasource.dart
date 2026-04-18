import 'dart:io';
import 'package:path/path.dart' as p;
import '../../domain/entities/track.dart';
import 'metadata_extractor.dart';

class LocalMusicDatasource {
  final MetadataExtractor _metadataExtractor;

  LocalMusicDatasource({MetadataExtractor? metadataExtractor})
      : _metadataExtractor = metadataExtractor ?? MetadataExtractor();

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
    try {
      final metadata = await _metadataExtractor.extractMetadata(file.path);
      
      String? albumArtPath;
      if (metadata.albumArt != null) {
        albumArtPath = file.path.replaceAll(RegExp(r'\.[^.]+$'), '_cover.jpg');
        final coverFile = File(albumArtPath);
        await coverFile.writeAsBytes(metadata.albumArt!);
      }

      return Track(
        id: file.path.hashCode.toString(),
        title: metadata.title,
        artist: metadata.artist,
        album: metadata.album,
        filePath: file.path,
        duration: metadata.duration,
        albumArt: albumArtPath,
      );
    } catch (e) {
      final fileName = p.basenameWithoutExtension(file.path);
      final parts = fileName.split(' - ');
      
      return Track(
        id: file.path.hashCode.toString(),
        title: parts.length >= 2 ? parts.sublist(1).join(' - ').trim() : fileName,
        artist: parts.length >= 2 ? parts[0].trim() : 'Unknown Artist',
        album: null,
        filePath: file.path,
        duration: Duration.zero,
        albumArt: null,
      );
    }
  }
}