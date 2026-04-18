import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('PlayerState - Shuffle and Repeat', () {
    test('should have shuffle disabled by default', () {
      final state = PlayerState.initial();
      expect(state.isShuffleEnabled, isFalse);
    });

    test('should have repeat mode as none by default', () {
      final state = PlayerState.initial();
      expect(state.repeatMode, RepeatMode.none);
    });

    test('should toggle shuffle', () {
      final state = PlayerState.initial();
      final toggled = state.toggleShuffle();
      expect(toggled.isShuffleEnabled, isTrue);
    });

    test('should toggle repeat mode in order: none -> all -> one -> none', () {
      var state = PlayerState.initial();
      
      state = state.toggleRepeat();
      expect(state.repeatMode, RepeatMode.all);
      
      state = state.toggleRepeat();
      expect(state.repeatMode, RepeatMode.one);
      
      state = state.toggleRepeat();
      expect(state.repeatMode, RepeatMode.none);
    });

    test('should shuffle playlist', () {
      final tracks = [
        Track(id: '1', title: 'A', artist: 'A', filePath: '/1.mp3', duration: const Duration(minutes: 1)),
        Track(id: '2', title: 'B', artist: 'B', filePath: '/2.mp3', duration: const Duration(minutes: 2)),
        Track(id: '3', title: 'C', artist: 'C', filePath: '/3.mp3', duration: const Duration(minutes: 3)),
      ];
      
      final shuffled = PlayerState.shuffleList(tracks, 0);
      expect(shuffled.length, 3);
      expect(shuffled.contains(tracks[0]), isTrue);
      expect(shuffled.contains(tracks[1]), isTrue);
      expect(shuffled.contains(tracks[2]), isTrue);
    });

    test('should handle empty playlist for shuffle', () {
      final shuffled = PlayerState.shuffleList([], 0);
      expect(shuffled, isEmpty);
    });
  });
}

enum RepeatMode { none, all, one }

class PlayerState {
  final bool isShuffleEnabled;
  final RepeatMode repeatMode;

  const PlayerState({
    required this.isShuffleEnabled,
    required this.repeatMode,
  });

  factory PlayerState.initial() => const PlayerState(
    isShuffleEnabled: false,
    repeatMode: RepeatMode.none,
  );

  PlayerState toggleShuffle() => PlayerState(
    isShuffleEnabled: !isShuffleEnabled,
    repeatMode: repeatMode,
  );

  PlayerState toggleRepeat() {
    final nextMode = switch (repeatMode) {
      RepeatMode.none => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.none,
    };
    return PlayerState(
      isShuffleEnabled: isShuffleEnabled,
      repeatMode: nextMode,
    );
  }

  static List<Track> shuffleList(List<Track> tracks, int currentIndex) {
    if (tracks.length <= 1) return tracks;
    final shuffled = List<Track>.from(tracks);
    shuffled.shuffle();
    return shuffled;
  }
}