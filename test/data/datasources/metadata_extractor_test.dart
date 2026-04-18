import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/data/datasources/metadata_extractor.dart';

void main() {
  group('MetadataExtractor', () {
    late MetadataExtractor extractor;

    setUp(() {
      extractor = MetadataExtractor();
    });

    test('should have extractMetadata method', () {
      expect(extractor.extractMetadata, isA<Function>());
    });

    test('TrackMetadata should have required fields', () {
      final metadata = TrackMetadata(
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3),
        albumArt: null,
      );

      expect(metadata.title, 'Test Song');
      expect(metadata.artist, 'Test Artist');
      expect(metadata.album, 'Test Album');
      expect(metadata.duration, const Duration(minutes: 3));
    });
  });
}