import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/data/datasources/local_music_datasource.dart';

void main() {
  late LocalMusicDatasource datasource;

  setUp(() {
    datasource = LocalMusicDatasource();
  });

  group('LocalMusicDatasource', () {
    test('should return empty list for non-existent directory', () async {
      final tracks = await datasource.scanDirectory('/non/existent/path');
      expect(tracks, isEmpty);
    });
  });
}