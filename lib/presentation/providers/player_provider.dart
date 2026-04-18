import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/audio_player_repository.dart';
import '../../data/services/audio_player_service.dart';

enum RepeatMode { none, all, one }

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

class PlayerProvider extends ChangeNotifier {
  final AudioPlayerRepository _audioPlayer;
  Track? _currentTrack;
  List<Track> _playlist = [];
  List<Track> _originalPlaylist = [];
  List<Playlist> _playlists = [];
  PlayHistory _history = const PlayHistory();
  int _currentIndex = 0;
  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isPlaying = false;
  bool _isShuffleEnabled = false;
  RepeatMode _repeatMode = RepeatMode.none;

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
  List<Track> get recentHistory => _history.getRecent(10);
  int get currentIndex => _currentIndex;
  bool get isShuffleEnabled => _isShuffleEnabled;
  RepeatMode get repeatMode => _repeatMode;

  Future<void> playTrack(Track track, {List<Track>? playlist, int? index}) async {
    if (playlist != null) {
      _originalPlaylist = playlist;
      if (_isShuffleEnabled) {
        _playlist = _shuffleList(playlist, index ?? 0);
        _currentIndex = 0;
      } else {
        _playlist = playlist;
        _currentIndex = index ?? 0;
      }
    }
    _currentTrack = track;
    _history = _history.addTrack(track);
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
    if (_playlist.isEmpty) return;
    
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = 0;
    } else if (_repeatMode == RepeatMode.one) {
      _currentIndex = _currentIndex;
    } else {
      return;
    }
    
    await playTrack(_playlist[_currentIndex]);
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    
    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    
    if (_currentIndex > 0) {
      _currentIndex--;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = _playlist.length - 1;
    } else {
      return;
    }
    
    await playTrack(_playlist[_currentIndex]);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;
    
    if (_isShuffleEnabled) {
      _playlist = _shuffleList(_originalPlaylist, _currentIndex);
      _currentIndex = _playlist.indexWhere((t) => t.id == _currentTrack?.id);
      if (_currentIndex == -1) _currentIndex = 0;
    } else {
      _currentIndex = _originalPlaylist.indexWhere((t) => t.id == _currentTrack?.id);
      if (_currentIndex == -1) _currentIndex = 0;
      _playlist = _originalPlaylist;
    }
    
    notifyListeners();
  }

  void toggleRepeat() {
    _repeatMode = switch (_repeatMode) {
      RepeatMode.none => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.none,
    };
    notifyListeners();
  }

  List<Track> _shuffleList(List<Track> tracks, int currentIndex) {
    if (tracks.length <= 1) return tracks;
    
    final currentTrack = tracks[currentIndex];
    final others = tracks.where((t) => t.id != currentTrack.id).toList();
    others.shuffle();
    
    return [currentTrack, ...others];
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