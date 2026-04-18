import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('FavoritesManager', () {
    test('should add track to favorites', () {
      final manager = FavoritesManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final updated = manager.addFavorite(track);
      
      expect(updated.favorites.length, 1);
      expect(updated.favorites.first.id, '1');
    });

    test('should remove track from favorites', () {
      final manager = FavoritesManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final withFavorite = manager.addFavorite(track);
      final removed = withFavorite.removeFavorite('1');
      
      expect(removed.favorites, isEmpty);
    });

    test('should check if track is favorite', () {
      final manager = FavoritesManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final withFavorite = manager.addFavorite(track);
      
      expect(withFavorite.isFavorite('1'), isTrue);
      expect(withFavorite.isFavorite('2'), isFalse);
    });

    test('should not add duplicate favorite', () {
      final manager = FavoritesManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final updated = manager.addFavorite(track).addFavorite(track);
      
      expect(updated.favorites.length, 1);
    });

    test('should clear all favorites', () {
      final manager = FavoritesManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      final withFavorites = manager.addFavorite(track1).addFavorite(track2);
      final cleared = withFavorites.clearFavorites();
      
      expect(cleared.favorites, isEmpty);
    });

    test('should get favorite count', () {
      final manager = FavoritesManager();
      final track1 = Track(id: '1', title: 'Song1', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      final track2 = Track(id: '2', title: 'Song2', artist: 'Artist', filePath: '/2.mp3', duration: const Duration(minutes: 4));
      
      final updated = manager.addFavorite(track1).addFavorite(track2);
      
      expect(updated.favoriteCount, 2);
    });

    test('should toggle favorite', () {
      final manager = FavoritesManager();
      final track = Track(id: '1', title: 'Song', artist: 'Artist', filePath: '/1.mp3', duration: const Duration(minutes: 3));
      
      final added = manager.toggleFavorite(track);
      expect(added.favorites.length, 1);
      
      final removed = added.toggleFavorite(track);
      expect(removed.favorites, isEmpty);
    });
  });
}

class FavoritesManager {
  final List<Track> favorites;
  
  const FavoritesManager({this.favorites = const []});
  
  FavoritesManager addFavorite(Track track) {
    if (favorites.any((t) => t.id == track.id)) {
      return this;
    }
    return FavoritesManager(favorites: [...favorites, track]);
  }
  
  FavoritesManager removeFavorite(String trackId) {
    return FavoritesManager(
      favorites: favorites.where((t) => t.id != trackId).toList(),
    );
  }
  
  bool isFavorite(String trackId) => favorites.any((t) => t.id == trackId);
  
  FavoritesManager clearFavorites() => const FavoritesManager();
  
  int get favoriteCount => favorites.length;
  
  FavoritesManager toggleFavorite(Track track) {
    if (isFavorite(track.id)) {
      return removeFavorite(track.id);
    }
    return addFavorite(track);
  }
}