import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/presentation/providers/music_library_provider.dart';

void main() {
  group('MusicLibraryProvider', () {
    late MusicLibraryProvider provider;

    setUp(() {
      provider = MusicLibraryProvider();
    });

    test('should have initial state', () {
      expect(provider.state, LibraryLoadingState.initial);
      expect(provider.tracks, isEmpty);
    });

    test('should have loadLibrary method', () {
      expect(provider.loadLibrary, isA<Function>());
    });
  });
}