import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';
import 'package:sonioteca/data/repositories/music_library_repository_impl.dart';

void main() {
  group('MusicLibraryRepositoryImpl', () {
    late MusicLibraryRepositoryImpl repository;

    setUp(() {
      repository = MusicLibraryRepositoryImpl();
    });

    test('should return list of tracks', () async {
      final tracks = await repository.getAllTracks();
      expect(tracks, isA<List<Track>>());
    });

    test('should return tracks from specific folder', () async {
      final tracks = await repository.getTracksByFolder('/non/existent');
      expect(tracks, isEmpty);
    });
  });
}