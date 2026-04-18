import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Album grouping - Extended', () {
    test('should group single track album', () {
      final tracks = [
        Track(id: '1', title: 'Song', artist: 'Artist', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 1);
      expect(albums['Album1']?.length, 1);
    });

    test('should group multiple tracks from same album', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', album: 'Album1', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
        Track(id: '3', title: 'Song3', artist: 'Artist', album: 'Album1', filePath: '/3.mp3', duration: const Duration(minutes: 5)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 1);
      expect(albums['Album1']?.length, 3);
    });

    test('should handle null album as Unknown Album', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: null, filePath: '/1.mp3', duration: const Duration(minutes: 3)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.containsKey('Unknown Album'), isTrue);
    });

    test('should handle mixed null and non-null albums', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', album: null, filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 2);
    });

    test('should group by album name case sensitive', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', album: 'album1', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 2);
    });

    test('should handle empty track list', () {
      final albums = _groupAlbums([]);
      expect(albums, isEmpty);
    });

    test('should handle single album with many tracks', () {
      final tracks = List.generate(
        20,
        (i) => Track(id: '$i', title: 'Song $i', artist: 'Artist', album: 'Album1', filePath: '/$i.mp3', duration: Duration(minutes: 3 + i)),
      );
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 1);
      expect(albums['Album1']?.length, 20);
    });

    test('should handle multiple different albums', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'A', album: 'Album1', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'B', album: 'Album2', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
        Track(id: '3', title: 'Song3', artist: 'C', album: 'Album3', filePath: '/3.mp3', duration: const Duration(minutes: 5)),
        Track(id: '4', title: 'Song4', artist: 'D', album: 'Album4', filePath: '/4.mp3', duration: const Duration(minutes: 6)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 4);
    });

    test('should handle duplicate album names with different artists', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist1', album: 'Greatest Hits', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist2', album: 'Greatest Hits', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];
      
      final albums = _groupAlbums(tracks);
      expect(albums.length, 1);
      expect(albums['Greatest Hits']?.length, 2);
    });
  });
}

Map<String, List<Track>> _groupAlbums(List<Track> tracks) {
  final map = <String, List<Track>>{};
  for (final track in tracks) {
    final album = track.album ?? 'Unknown Album';
    map.putIfAbsent(album, () => []).add(track);
  }
  return map;
}