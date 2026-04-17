import '../entities/track.dart';

abstract class MusicLibraryRepository {
  Future<List<Track>> getAllTracks();
  Future<List<Track>> getTracksByFolder(String folderPath);
}