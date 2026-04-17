import 'package:just_audio/just_audio.dart';
import '../../domain/entities/entities.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer;
  Track? _currentTrack;

  AudioPlayerService({AudioPlayer? audioPlayer}) : _audioPlayer = audioPlayer ?? AudioPlayer();

  Track? get currentTrack => _currentTrack;

  Stream<Duration> get currentPosition => _audioPlayer.positionStream;

  Stream<bool> get isPlaying => _audioPlayer.playingStream;

  Stream<Duration?> get duration => _audioPlayer.durationStream;

  Future<void> play(Track track) async {
    _currentTrack = track;
    await _audioPlayer.setFilePath(track.filePath);
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentTrack = null;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}