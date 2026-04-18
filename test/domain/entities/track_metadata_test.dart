import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track metadata', () {
    test('should create track with all metadata fields', () {
      final track = Track(
        id: '1',
        title: 'Song Title',
        artist: 'Artist Name',
        album: 'Album Name',
        filePath: '/path/song.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
        albumArt: '/path/cover.jpg',
      );

      expect(track.title, 'Song Title');
      expect(track.artist, 'Artist Name');
      expect(track.album, 'Album Name');
      expect(track.albumArt, '/path/cover.jpg');
    });

    test('should support equality with metadata', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
        albumArt: '/art.jpg',
      );

      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
        albumArt: '/art.jpg',
      );

      expect(track1, equals(track2));
    });
  });
}