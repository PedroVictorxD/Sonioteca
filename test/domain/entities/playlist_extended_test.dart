import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Playlist entity - Extended', () {
    test('should create empty playlist', () {
      final playlist = Playlist(
        id: '1',
        name: 'Empty Playlist',
        tracks: [],
      );
      
      expect(playlist.tracks, isEmpty);
      expect(playlist.trackCount, 0);
      expect(playlist.totalDuration, Duration.zero);
    });

    test('should calculate trackCount correctly', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
          Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2)),
          Track(id: '3', title: 'S3', artist: 'A', filePath: '/3.mp3', duration: const Duration(minutes: 3)),
        ],
      );
      
      expect(playlist.trackCount, 3);
    });

    test('should calculate totalDuration correctly', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
          Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2, seconds: 30)),
          Track(id: '3', title: 'S3', artist: 'A', filePath: '/3.mp3', duration: const Duration(minutes: 3, seconds: 15)),
        ],
      );
      
      expect(playlist.totalDuration, const Duration(minutes: 6, seconds: 45));
    });

    test('addTrack should add track to empty playlist', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [],
      );
      
      final newTrack = Track(id: '1', title: 'New', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1));
      final updated = playlist.addTrack(newTrack);
      
      expect(updated.tracks.length, 1);
      expect(updated.tracks.first.title, 'New');
    });

    test('addTrack should add track to existing playlist', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
        ],
      );
      
      final newTrack = Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2));
      final updated = playlist.addTrack(newTrack);
      
      expect(updated.tracks.length, 2);
    });

    test('addTrack should not modify original playlist', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
        ],
      );
      
      final newTrack = Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2));
      playlist.addTrack(newTrack);
      
      expect(playlist.tracks.length, 1);
    });

    test('removeTrack should remove existing track', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
          Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2)),
        ],
      );
      
      final updated = playlist.removeTrack('1');
      
      expect(updated.tracks.length, 1);
      expect(updated.tracks.first.id, '2');
    });

    test('removeTrack should not modify original playlist', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
          Track(id: '2', title: 'S2', artist: 'A', filePath: '/2.mp3', duration: const Duration(minutes: 2)),
        ],
      );
      
      playlist.removeTrack('1');
      
      expect(playlist.tracks.length, 2);
    });

    test('removeTrack should return same playlist if track not found', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
        ],
      );
      
      final updated = playlist.removeTrack('999');
      
      expect(updated.tracks.length, 1);
      expect(updated.tracks.first.id, '1');
    });

    test('should have correct equality', () {
      final p1 = Playlist(id: '1', name: 'Test', tracks: []);
      final p2 = Playlist(id: '1', name: 'Test', tracks: []);
      
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
    });

    test('should have different equality for different ids', () {
      final p1 = Playlist(id: '1', name: 'Test', tracks: []);
      final p2 = Playlist(id: '2', name: 'Test', tracks: []);
      
      expect(p1, isNot(equals(p2)));
    });

    test('should have different equality for different names', () {
      final p1 = Playlist(id: '1', name: 'Test1', tracks: []);
      final p2 = Playlist(id: '1', name: 'Test2', tracks: []);
      
      expect(p1, isNot(equals(p2)));
    });

    test('should handle same tracks in different playlists as equal', () {
      final tracks = [
        Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
      ];
      
      final p1 = Playlist(id: '1', name: 'Test', tracks: tracks);
      final p2 = Playlist(id: '1', name: 'Test', tracks: tracks);
      
      expect(p1, equals(p2));
    });

    test('should handle empty tracks in equality', () {
      final p1 = Playlist(id: '1', name: 'Test', tracks: []);
      final p2 = Playlist(id: '1', name: 'Test', tracks: []);
      
      expect(p1, equals(p2));
    });

    test('totalDuration should handle empty playlist', () {
      final playlist = Playlist(id: '1', name: 'Test', tracks: []);
      
      expect(playlist.totalDuration, Duration.zero);
    });

    test('totalDuration should handle single track', () {
      final playlist = Playlist(
        id: '1',
        name: 'Test',
        tracks: [
          Track(id: '1', title: 'S1', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 5, seconds: 30)),
        ],
      );
      
      expect(playlist.totalDuration, const Duration(minutes: 5, seconds: 30));
    });

    test('trackCount should handle empty playlist', () {
      final playlist = Playlist(id: '1', name: 'Test', tracks: []);
      
      expect(playlist.trackCount, 0);
    });
  });
}