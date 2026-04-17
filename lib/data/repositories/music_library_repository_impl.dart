import 'dart:io';
import '../../domain/entities/track.dart';
import '../../domain/repositories/music_library_repository.dart';
import '../datasources/local_music_datasource.dart';

class MusicLibraryRepositoryImpl implements MusicLibraryRepository {
  final LocalMusicDatasource _datasource;

  MusicLibraryRepositoryImpl({LocalMusicDatasource? datasource})
      : _datasource = datasource ?? LocalMusicDatasource();

  @override
  Future<List<Track>> getAllTracks() async {
    final directories = await _getMusicDirectories();
    final allTracks = <Track>[];
    
    for (final dir in directories) {
      final tracks = await _datasource.scanDirectory(dir);
      allTracks.addAll(tracks);
    }
    
    return allTracks;
  }

  @override
  Future<List<Track>> getTracksByFolder(String folderPath) async {
    return _datasource.scanDirectory(folderPath);
  }

  Future<List<String>> _getMusicDirectories() async {
    if (Platform.isAndroid) {
      return [
        '/storage/emulated/0/Music',
        '/storage/emulated/0/Download',
        '/storage/emulated/0/DCIM',
      ];
    } else if (Platform.isIOS) {
      return [];
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return [
        '/home/${Platform.environment['USER']}/Music',
      ];
    }
    return [];
  }
}