import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Album grouping', () {
    test('should group tracks by album', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', album: 'Album1', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
        Track(id: '3', title: 'Song3', artist: 'Artist', album: 'Album2', filePath: '/3.mp3', duration: const Duration(minutes: 5)),
      ];

      final albumMap = _groupByAlbum(tracks);
      
      expect(albumMap.keys.length, 2);
      expect(albumMap['Album1']?.length, 2);
      expect(albumMap['Album2']?.length, 1);
    });

    test('should handle tracks with null album', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: null, filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', album: 'Album1', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];

      final albumMap = _groupByAlbum(tracks);
      
      expect(albumMap.containsKey('Unknown Album'), isTrue);
      expect(albumMap['Unknown Album']?.length, 1);
    });
  });
}

Map<String, List<Track>> _groupByAlbum(List<Track> tracks) {
  final map = <String, List<Track>>{};
  for (final track in tracks) {
    final album = track.album ?? 'Unknown Album';
    map.putIfAbsent(album, () => []).add(track);
  }
  return map;
}