import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/audio_player_repository.dart';
import '../../data/services/audio_player_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayerRepository _audioPlayer;
  Track? _currentTrack;
  List<Track> _playlist = [];
  List<Playlist> _playlists = [];
  int _currentIndex = 0;
  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isPlaying = false;

  PlayerProvider({AudioPlayerRepository? audioPlayer})
      : _audioPlayer = audioPlayer ?? AudioPlayerService() {
    _initStreams();
  }

  void _initStreams() {
    _audioPlayer.currentPosition.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _audioPlayer.isPlaying.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });
    _audioPlayer.duration.listen((dur) {
      _duration = dur;
      notifyListeners();
    });
  }

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration? get duration => _duration;
  List<Track> get playlist => _playlist;
  List<Playlist> get playlists => _playlists;
  int get currentIndex => _currentIndex;

  Future<void> playTrack(Track track, {List<Track>? playlist, int? index}) async {
    if (playlist != null) {
      _playlist = playlist;
      _currentIndex = index ?? 0;
    }
    _currentTrack = track;
    await _audioPlayer.play(track);
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> next() async {
    if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await playTrack(_playlist[_currentIndex]);
    }
  }

  Future<void> previous() async {
    if (_playlist.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      await playTrack(_playlist[_currentIndex]);
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void createPlaylist(Playlist playlist) {
    _playlists.add(playlist);
    notifyListeners();
  }

  void deletePlaylist(String id) {
    _playlists.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addTrackToPlaylist(String playlistId, Track track) {
    final index = _playlists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      _playlists[index] = _playlists[index].addTrack(track);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}