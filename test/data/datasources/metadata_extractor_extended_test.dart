import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/data/datasources/metadata_extractor.dart';

void main() {
  group('MetadataExtractor - Extended', () {
    late MetadataExtractor extractor;

    setUp(() {
      extractor = MetadataExtractor();
    });

    test('should have extractMetadata method', () {
      expect(extractor.extractMetadata, isA<Function>());
    });

    test('TrackMetadata should have title field', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3),
        albumArt: null,
      );
      expect(metadata.title, 'Test Title');
    });

    test('TrackMetadata should have artist field', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3),
        albumArt: null,
      );
      expect(metadata.artist, 'Test Artist');
    });

    test('TrackMetadata should have optional album field', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3),
        albumArt: null,
      );
      expect(metadata.album, 'Test Album');
    });

    test('TrackMetadata should allow null album', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: null,
        duration: const Duration(minutes: 3),
        albumArt: null,
      );
      expect(metadata.album, isNull);
    });

    test('TrackMetadata should have duration field', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3, seconds: 30),
        albumArt: null,
      );
      expect(metadata.duration, const Duration(minutes: 3, seconds: 30));
    });

    test('TrackMetadata should handle zero duration', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: null,
        duration: Duration.zero,
        albumArt: null,
      );
      expect(metadata.duration, Duration.zero);
    });

    test('TrackMetadata should have optional albumArt field', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: const Duration(minutes: 3),
        albumArt: [1, 2, 3, 4],
      );
      expect(metadata.albumArt, isNotNull);
      expect(metadata.albumArt?.length, 4);
    });

    test('TrackMetadata should allow null albumArt', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: null,
        duration: const Duration(minutes: 3),
        albumArt: null,
      );
      expect(metadata.albumArt, isNull);
    });

    test('TrackMetadata should handle long durations', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: null,
        duration: const Duration(hours: 1, minutes: 30),
        albumArt: null,
      );
      expect(metadata.duration.inMinutes, 90);
    });

    test('TrackMetadata should handle empty bytes albumArt', () {
      final metadata = TrackMetadata(
        title: 'Test Title',
        artist: 'Test Artist',
        album: null,
        duration: const Duration(minutes: 3),
        albumArt: [],
      );
      expect(metadata.albumArt, isNotNull);
      expect(metadata.albumArt?.isEmpty, isTrue);
    });
  });
}