import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/track.dart';
import '../../data/repositories/music_library_repository_impl.dart';

enum LibraryLoadingState { initial, loading, loaded, error, noPermission }

class MusicLibraryProvider extends ChangeNotifier {
  final MusicLibraryRepositoryImpl _repository;
  List<Track> _tracks = [];
  LibraryLoadingState _state = LibraryLoadingState.initial;
  String _errorMessage = '';

  MusicLibraryProvider({MusicLibraryRepositoryImpl? repository})
      : _repository = repository ?? MusicLibraryRepositoryImpl();

  List<Track> get tracks => _tracks;
  LibraryLoadingState get state => _state;
  String get errorMessage => _errorMessage;

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
      _state = LibraryLoadingState.loaded;
    } catch (e) {
      _state = LibraryLoadingState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
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