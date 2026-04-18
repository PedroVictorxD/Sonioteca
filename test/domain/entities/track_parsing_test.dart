import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track parsing from filename', () {
    test('should parse "Artist - Title.mp3" format', () {
      final track = _parseTrack('Artist - Title.mp3', '/path/song.mp3');
      
      expect(track.title, 'Title');
      expect(track.artist, 'Artist');
    });

    test('should handle title with multiple dashes', () {
      final track = _parseTrack('Artist - Song - Part.mp3', '/path/song.mp3');
      
      expect(track.title, 'Song - Part');
      expect(track.artist, 'Artist');
    });

    test('should handle file without artist prefix', () {
      final track = _parseTrack('Just The Song.mp3', '/path/song.mp3');
      
      expect(track.title, 'Just The Song');
      expect(track.artist, 'Unknown Artist');
    });
  });
}

Track _parseTrack(String filename, String filePath) {
  final parts = filename.replaceAll(RegExp(r'\.[^.]+$'), '').split(' - ');
  
  String title = filename.replaceAll(RegExp(r'\.[^.]+$'), '');
  String artist = 'Unknown Artist';

  if (parts.length >= 2) {
    artist = parts[0].trim();
    title = parts.sublist(1).join(' - ').trim();
  }

  return Track(
    id: filePath.hashCode.toString(),
    title: title,
    artist: artist,
    filePath: filePath,
    duration: Duration.zero,
  );
}