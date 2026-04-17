import '../entities/track.dart';

abstract class AudioPlayerRepository {
  Future<void> play(Track track);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Stream<Duration> get currentPosition;
  Stream<bool> get isPlaying;
  Stream<Duration?> get duration;
  Future<void> dispose();
}