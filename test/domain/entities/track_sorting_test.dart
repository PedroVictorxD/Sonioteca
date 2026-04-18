import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track sorting', () {
    final tracks = [
      Track(id: '1', title: 'Zebra', artist: 'Artist A', album: 'Album A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
      Track(id: '2', title: 'Apple', artist: 'Artist B', album: 'Album B', filePath: '/2.mp3', duration: const Duration(minutes: 2)),
      Track(id: '3', title: 'Banana', artist: 'Artist C', album: 'Album C', filePath: '/3.mp3', duration: const Duration(minutes: 3)),
    ];

    test('should sort by title ascending', () {
      final sorted = _sortTracks(tracks, SortOption.titleAsc);
      expect(sorted[0].title, 'Apple');
      expect(sorted[1].title, 'Banana');
      expect(sorted[2].title, 'Zebra');
    });

    test('should sort by title descending', () {
      final sorted = _sortTracks(tracks, SortOption.titleDesc);
      expect(sorted[0].title, 'Zebra');
      expect(sorted[1].title, 'Banana');
      expect(sorted[2].title, 'Apple');
    });

    test('should sort by artist ascending', () {
      final sorted = _sortTracks(tracks, SortOption.artistAsc);
      expect(sorted[0].artist, 'Artist A');
      expect(sorted[1].artist, 'Artist B');
      expect(sorted[2].artist, 'Artist C');
    });

    test('should sort by artist descending', () {
      final sorted = _sortTracks(tracks, SortOption.artistDesc);
      expect(sorted[0].artist, 'Artist C');
      expect(sorted[1].artist, 'Artist B');
      expect(sorted[2].artist, 'Artist A');
    });

    test('should sort by album ascending', () {
      final sorted = _sortTracks(tracks, SortOption.albumAsc);
      expect(sorted[0].album, 'Album A');
      expect(sorted[1].album, 'Album B');
      expect(sorted[2].album, 'Album C');
    });

    test('should sort by album descending', () {
      final sorted = _sortTracks(tracks, SortOption.albumDesc);
      expect(sorted[0].album, 'Album C');
      expect(sorted[1].album, 'Album B');
      expect(sorted[2].album, 'Album A');
    });

    test('should not modify original list', () {
      _sortTracks(tracks, SortOption.titleAsc);
      expect(tracks[0].title, 'Zebra');
    });

    test('should handle empty list', () {
      final sorted = _sortTracks([], SortOption.titleAsc);
      expect(sorted, isEmpty);
    });

    test('should handle single item list', () {
      final single = [tracks[0]];
      final sorted = _sortTracks(single, SortOption.titleAsc);
      expect(sorted.length, 1);
    });
  });
}

enum SortOption { titleAsc, titleDesc, artistAsc, artistDesc, albumAsc, albumDesc }

List<Track> _sortTracks(List<Track> tracks, SortOption option) {
  final sorted = List<Track>.from(tracks);
  
  switch (option) {
    case SortOption.titleAsc:
      sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    case SortOption.titleDesc:
      sorted.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    case SortOption.artistAsc:
      sorted.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
    case SortOption.artistDesc:
      sorted.sort((a, b) => b.artist.toLowerCase().compareTo(a.artist.toLowerCase()));
    case SortOption.albumAsc:
      sorted.sort((a, b) => (a.album ?? '').toLowerCase().compareTo((b.album ?? '').toLowerCase()));
    case SortOption.albumDesc:
      sorted.sort((a, b) => (b.album ?? '').toLowerCase().compareTo((a.album ?? '').toLowerCase()));
  }
  
  return sorted;
}