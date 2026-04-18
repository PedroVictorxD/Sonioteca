import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Playlist entity', () {
    test('should create playlist with name and tracks', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];

      final playlist = Playlist(
        id: 'playlist1',
        name: 'My Playlist',
        tracks: tracks,
      );

      expect(playlist.name, 'My Playlist');
      expect(playlist.tracks.length, 2);
      expect(playlist.trackCount, 2);
    });

    test('should calculate total duration', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
        Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4)),
      ];

      final playlist = Playlist(
        id: 'playlist1',
        name: 'My Playlist',
        tracks: tracks,
      );

      expect(playlist.totalDuration, const Duration(minutes: 7));
    });

    test('should add track to playlist', () {
      final playlist = Playlist(
        id: 'playlist1',
        name: 'My Playlist',
        tracks: [],
      );

      final newTrack = Track(id: '1', title: 'New Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final updatedPlaylist = playlist.addTrack(newTrack);

      expect(updatedPlaylist.tracks.length, 1);
    });

    test('should remove track from playlist', () {
      final tracks = [
        Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3)),
      ];

      final playlist = Playlist(
        id: 'playlist1',
        name: 'My Playlist',
        tracks: tracks,
      );

      final updatedPlaylist = playlist.removeTrack('1');
      expect(updatedPlaylist.tracks.length, 0);
    });
  });
}