import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track', () {
    test('should create Track with required fields', () {
      final track = Track(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        filePath: '/path/to/song.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      );

      expect(track.id, '1');
      expect(track.title, 'Test Song');
      expect(track.artist, 'Test Artist');
      expect(track.filePath, '/path/to/song.mp3');
      expect(track.duration, const Duration(minutes: 3, seconds: 30));
      expect(track.albumArt, isNull);
    });

    test('should create Track with optional albumArt', () {
      final track = Track(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        filePath: '/path/to/song.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
        albumArt: '/path/to/art.jpg',
      );

      expect(track.albumArt, '/path/to/art.jpg');
    });

    test('should support value equality', () {
      final track1 = Track(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        filePath: '/path/to/song.mp3',
        duration: const Duration(minutes: 3),
      );

      final track2 = Track(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        filePath: '/path/to/song.mp3',
        duration: const Duration(minutes: 3),
      );

      expect(track1, equals(track2));
    });
  });

  group('Playlist', () {
    test('should create Playlist with required fields', () {
      final tracks = [
        Track(
          id: '1',
          title: 'Song 1',
          artist: 'Artist',
          filePath: '/path/1.mp3',
          duration: const Duration(minutes: 3),
        ),
        Track(
          id: '2',
          title: 'Song 2',
          artist: 'Artist',
          filePath: '/path/2.mp3',
          duration: const Duration(minutes: 4),
        ),
      ];

      final playlist = Playlist(
        id: 'playlist1',
        name: 'My Playlist',
        tracks: tracks,
      );

      expect(playlist.id, 'playlist1');
      expect(playlist.name, 'My Playlist');
      expect(playlist.tracks.length, 2);
    });

    test('should support value equality', () {
      final tracks = [
        Track(
          id: '1',
          title: 'Song 1',
          artist: 'Artist',
          filePath: '/path/1.mp3',
          duration: const Duration(minutes: 3),
        ),
      ];

      final playlist1 = Playlist(id: '1', name: 'Test', tracks: tracks);
      final playlist2 = Playlist(id: '1', name: 'Test', tracks: tracks);

      expect(playlist1, equals(playlist2));
    });
  });
}