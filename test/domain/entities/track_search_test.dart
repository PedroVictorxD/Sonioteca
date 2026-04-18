import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track search', () {
    test('should filter tracks by title', () {
      final tracks = [
        Track(id: '1', title: 'Song One', artist: 'Artist A', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Another Song', artist: 'Artist B', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
        Track(id: '3', title: 'First Song', artist: 'Artist A', filePath: '/3.mp3', duration: const Duration(minutes: 5)),
      ];

      final results = _searchTracks(tracks, 'Song');
      
      expect(results.length, 3);
    });

    test('should filter tracks by artist', () {
      final tracks = [
        Track(id: '1', title: 'Song One', artist: 'Pink Floyd', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Another Song', artist: 'Metallica', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
        Track(id: '3', title: 'First Song', artist: 'Pink Floyd', filePath: '/3.mp3', duration: const Duration(minutes: 5)),
      ];

      final results = _searchTracks(tracks, 'Pink');
      
      expect(results.length, 2);
    });

    test('should be case insensitive', () {
      final tracks = [
        Track(id: '1', title: 'SONG ONE', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
      ];

      final results = _searchTracks(tracks, 'song');
      
      expect(results.length, 1);
    });

    test('should return empty list for no matches', () {
      final tracks = [
        Track(id: '1', title: 'Song One', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
      ];

      final results = _searchTracks(tracks, 'Nonexistent');
      
      expect(results, isEmpty);
    });
  });
}

List<Track> _searchTracks(List<Track> tracks, String query) {
  final lowerQuery = query.toLowerCase();
  return tracks.where((track) {
    return track.title.toLowerCase().contains(lowerQuery) ||
           track.artist.toLowerCase().contains(lowerQuery) ||
           (track.album?.toLowerCase().contains(lowerQuery) ?? false);
  }).toList();
}