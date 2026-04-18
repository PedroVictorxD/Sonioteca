import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/track.dart';
import '../../data/repositories/music_library_repository_impl.dart';

enum LibraryLoadingState { initial, loading, loaded, error, noPermission }

enum SortOption { titleAsc, titleDesc, artistAsc, artistDesc, albumAsc, albumDesc }

class MusicLibraryProvider extends ChangeNotifier {
  final MusicLibraryRepositoryImpl _repository;
  List<Track> _tracks = [];
  List<Track> _sortedTracks = [];
  LibraryLoadingState _state = LibraryLoadingState.initial;
  String _errorMessage = '';
  SortOption _currentSort = SortOption.titleAsc;

  MusicLibraryProvider({MusicLibraryRepositoryImpl? repository})
      : _repository = repository ?? MusicLibraryRepositoryImpl();

  List<Track> get tracks => _sortedTracks.isEmpty ? _tracks : _sortedTracks;
  LibraryLoadingState get state => _state;
  String get errorMessage => _errorMessage;
  SortOption get currentSort => _currentSort;

  Future<void> loadLibrary() async {
    _state = LibraryLoadingState.loading;
    notifyListeners();

    try {
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        _state = LibraryLoadingState.noPermission;
        _errorMessage = 'Permissão de armazenamento negada';
        notifyListeners();
        return;
      }

      _tracks = await _repository.getAllTracks();
      _sortedTracks = _sortTracks(_tracks, _currentSort);
      _state = LibraryLoadingState.loaded;
    } catch (e) {
      _state = LibraryLoadingState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void setSort(SortOption option) {
    _currentSort = option;
    _sortedTracks = _sortTracks(_tracks, option);
    notifyListeners();
  }

  List<Track> _sortTracks(List<Track> tracks, SortOption option) {
    final sorted = List<Track>.from(tracks);
    
    switch (option) {
      case SortOption.titleAsc:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case SortOption.titleDesc:
        sorted.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
      case SortOption.artistAsc:
        sorted.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
      case SortOption.artistDesc:
        sorted.sort((a, b) => b.artist.toLowerCase().compareTo(a.artist.toLowerCase()));
      case SortOption.albumAsc:
        sorted.sort((a, b) => (a.album ?? '').toLowerCase().compareTo((b.album ?? '').toLowerCase()));
      case SortOption.albumDesc:
        sorted.sort((a, b) => (b.album ?? '').toLowerCase().compareTo((a.album ?? '').toLowerCase()));
    }
    
    return sorted;
  }

  Future<bool> _requestPermission() async {
    if (await Permission.audio.isGranted || await Permission.storage.isGranted) {
      return true;
    }

    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) return true;

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> requestPermission() async {
    await openAppSettings();
  }
}