import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track entity', () {
    test('should create track with required fields', () {
      final track = Track(
        id: '1',
        title: 'Test',
        artist: 'Artist',
        filePath: '/path.mp3',
        duration: const Duration(minutes: 3),
      );
      expect(track.title, 'Test');
      expect(track.artist, 'Artist');
    });
  });
}