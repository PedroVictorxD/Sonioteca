import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('PlayHistory', () {
    test('should add track to history', () {
      final history = PlayHistory();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final updated = history.addTrack(track);
      
      expect(updated.tracks.length, 1);
      expect(updated.tracks.first.id, '1');
    });

    test('should add multiple tracks to history', () {
      final history = PlayHistory();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      var updated = history.addTrack(track1);
      updated = updated.addTrack(track2);
      
      expect(updated.tracks.length, 2);
    });

    test('should not add duplicate consecutively', () {
      final history = PlayHistory();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final updated = history.addTrack(track).addTrack(track);
      
      expect(updated.tracks.length, 1);
    });

    test('should limit history to 50 tracks', () {
      final history = PlayHistory();
      var updated = history;
      
      for (int i = 0; i < 60; i++) {
        final track = Track(id: '$i', title: 'Song $i', artist: 'Artist', filePath: '/$i.mp3', duration: const Duration(minutes: 3));
        updated = updated.addTrack(track);
      }
      
      expect(updated.tracks.length, 50);
    });

    test('should clear history', () {
      final history = PlayHistory();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final withTrack = history.addTrack(track);
      final cleared = withTrack.clear();
      
      expect(cleared.tracks, isEmpty);
    });

    test('should get recently played tracks', () {
      final history = PlayHistory();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      final track3 = Track(id: '3', title: 'Song3', artist: 'Artist', filePath: '/3.mp3', duration: const Duration(minutes: 5));
      
      var updated = history.addTrack(track1).addTrack(track2).addTrack(track3);
      
      final recent = updated.getRecent(2);
      expect(recent.length, 2);
      expect(recent[0].id, '3');
      expect(recent[1].id, '2');
    });
  });
}

class PlayHistory {
  final List<Track> tracks;
  
  const PlayHistory({this.tracks = const []});
  
  PlayHistory addTrack(Track track) {
    if (tracks.isNotEmpty && tracks.first.id == track.id) {
      return this;
    }
    
    final newTracks = [track, ...tracks];
    if (newTracks.length > 50) {
      return PlayHistory(tracks: newTracks.take(50).toList());
    }
    return PlayHistory(tracks: newTracks);
  }
  
  PlayHistory clear() => const PlayHistory();
  
  List<Track> getRecent(int count) => tracks.take(count).toList();
}