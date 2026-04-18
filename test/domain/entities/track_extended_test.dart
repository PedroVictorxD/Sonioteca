import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track entity - Extended', () {
    test('should create track with only required fields', () {
      final track = Track(
        id: '1',
        title: 'Test',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 1),
      );
      
      expect(track.id, '1');
      expect(track.title, 'Test');
      expect(track.artist, 'Artist');
      expect(track.album, isNull);
      expect(track.albumArt, isNull);
    });

    test('should create track with all fields', () {
      final track = Track(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3, seconds: 45),
        albumArt: '/path/cover.jpg',
      );
      
      expect(track.album, 'Test Album');
      expect(track.albumArt, '/path/cover.jpg');
      expect(track.duration, const Duration(minutes: 3, seconds: 45));
    });

    test('should have correct equality for same track', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, equals(track2));
      expect(track1.hashCode, equals(track2.hashCode));
    });

    test('should have different equality for different tracks', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '2',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different album values', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album1',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        album: 'Album2',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different albumArt values', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
        albumArt: '/art1.jpg',
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
        albumArt: '/art2.jpg',
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different filePath values', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path1.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path2.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different duration values', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 5),
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different title values', () {
      final track1 = Track(
        id: '1',
        title: 'Song One',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song Two',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, isNot(equals(track2)));
    });

    test('should handle different artist values', () {
      final track1 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist One',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      final track2 = Track(
        id: '1',
        title: 'Song',
        artist: 'Artist Two',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      
      expect(track1, isNot(equals(track2)));
    });
  });
}