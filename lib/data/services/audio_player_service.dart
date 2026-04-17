import 'package:just_audio/just_audio.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/audio_player_repository.dart';

class AudioPlayerService implements AudioPlayerRepository {
  final AudioPlayer _audioPlayer;

  AudioPlayerService({AudioPlayer? audioPlayer}) : _audioPlayer = audioPlayer ?? AudioPlayer();

  @override
  Stream<Duration> get currentPosition => _audioPlayer.positionStream;

  @override
  Stream<bool> get isPlaying => _audioPlayer.playingStream;

  @override
  Stream<Duration?> get duration => _audioPlayer.durationStream;

  @override
  Future<void> play(Track track) async {
    await _audioPlayer.setFilePath(track.filePath);
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}