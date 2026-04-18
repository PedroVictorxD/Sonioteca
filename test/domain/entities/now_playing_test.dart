import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('NowPlayingInfo', () {
    test('should create NowPlayingInfo with track', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', album: 'Album', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: const Duration(minutes: 1),
        duration: const Duration(minutes: 3),
      );
      
      expect(info.track, track);
      expect(info.isPlaying, isTrue);
      expect(info.position, const Duration(minutes: 1));
      expect(info.duration, const Duration(minutes: 3));
    });

    test('should calculate progress percentage', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 5));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: const Duration(minutes: 2, seconds: 30),
        duration: const Duration(minutes: 5),
      );
      
      expect(info.progress, 0.5);
    });

    test('should handle zero duration for progress', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: Duration.zero);
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
      );
      
      expect(info.progress, 0.0);
    });

    test('should format remaining time', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: const Duration(minutes: 1),
        duration: const Duration(minutes: 3),
      );
      
      expect(info.remainingTime, const Duration(minutes: 2));
    });

    test('should format position correctly', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: const Duration(minutes: 1, seconds: 30),
        duration: const Duration(minutes: 3),
      );
      
      expect(info.formattedPosition, '01:30');
    });

    test('should format duration correctly', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3, seconds: 45));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: Duration.zero,
        duration: const Duration(minutes: 3, seconds: 45),
      );
      
      expect(info.formattedDuration, '03:45');
    });

    test('should handle isPlaying false', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: false,
        position: const Duration(minutes: 1),
        duration: const Duration(minutes: 3),
      );
      
      expect(info.isPlaying, isFalse);
    });

    test('should handle track without album', () {
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final info = NowPlayingInfo(
        track: track,
        isPlaying: true,
        position: Duration.zero,
        duration: const Duration(minutes: 3),
      );
      
      expect(info.track.album, isNull);
    });
  });
}

class NowPlayingInfo {
  final Track track;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  NowPlayingInfo({
    required this.track,
    required this.isPlaying,
    required this.position,
    required this.duration,
  });

  double get progress => duration.inSeconds > 0 
      ? position.inSeconds / duration.inSeconds 
      : 0.0;

  Duration get remainingTime => duration - position;

  String get formattedPosition {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedDuration {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}