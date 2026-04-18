import 'package:flutter_test/flutter_test.dart';
import 'package:sonioteca/domain/entities/track.dart';

void main() {
  group('Track parsing - Extended', () {
    test('should parse simple filename', () {
      final result = _parseFilename('Song Name.mp3');
      expect(result['title'], 'Song Name');
      expect(result['artist'], 'Unknown Artist');
    });

    test('should parse "Artist - Title" format', () {
      final result = _parseFilename('Pink Floyd - Comfortably Numb.mp3');
      expect(result['title'], 'Comfortably Numb');
      expect(result['artist'], 'Pink Floyd');
    });

    test('should parse title with multiple dashes', () {
      final result = _parseFilename('Artist - Song - Live Version.mp3');
      expect(result['title'], 'Song - Live Version');
      expect(result['artist'], 'Artist');
    });

    test('should handle track number format', () {
      final result = _parseFilename('01 - Artist - Song.mp3');
      expect(result['title'], 'Artist - Song');
      expect(result['artist'], '01');
    });

    test('should handle underscore in filename', () {
      final result = _parseFilename('Artist_Song_Title.mp3');
      expect(result['title'], 'Artist_Song_Title');
      expect(result['artist'], 'Unknown Artist');
    });

    test('should handle special characters', () {
      final result = _parseFilename("Artist - Song's Title (Remix).mp3");
      expect(result['title'], "Song's Title (Remix)");
      expect(result['artist'], 'Artist');
    });

    test('should handle empty filename', () {
      final result = _parseFilename('.mp3');
      expect(result['title'], '');
      expect(result['artist'], 'Unknown Artist');
    });

    test('should handle single word filename', () {
      final result = _parseFilename('Imagine.mp3');
      expect(result['title'], 'Imagine');
      expect(result['artist'], 'Unknown Artist');
    });

    test('should handle numeric filename', () {
      final result = _parseFilename('123.mp3');
      expect(result['title'], '123');
      expect(result['artist'], 'Unknown Artist');
    });

    test('should handle filename with dash at end', () {
      final result = _parseFilename('Metallica - .mp3');
      expect(result['artist'], 'Metallica');
    });
  });

  group('Audio file detection', () {
    test('should detect mp3 files', () {
      expect(_isAudioFile('song.mp3'), isTrue);
      expect(_isAudioFile('song.MP3'), isTrue);
    });

    test('should detect m4a files', () {
      expect(_isAudioFile('song.m4a'), isTrue);
      expect(_isAudioFile('song.M4A'), isTrue);
    });

    test('should detect wav files', () {
      expect(_isAudioFile('song.wav'), isTrue);
      expect(_isAudioFile('song.WAV'), isTrue);
    });

    test('should detect aac files', () {
      expect(_isAudioFile('song.aac'), isTrue);
    });

    test('should detect flac files', () {
      expect(_isAudioFile('song.flac'), isTrue);
    });

    test('should reject non-audio files', () {
      expect(_isAudioFile('document.pdf'), isFalse);
      expect(_isAudioFile('image.jpg'), isFalse);
      expect(_isAudioFile('video.mp4'), isFalse);
      expect(_isAudioFile('text.txt'), isFalse);
    });

    test('should reject files without extension', () {
      expect(_isAudioFile('songfile'), isFalse);
    });

    test('should handle file paths with directories', () {
      expect(_isAudioFile('/path/to/song.mp3'), isTrue);
      expect(_isAudioFile('C:\\Users\\music\\song.mp3'), isTrue);
    });

    test('should reject files with audio-like extension', () {
      expect(_isAudioFile('song.mp3x'), isFalse);
      expect(_isAudioFile('song.mp3.bak'), isFalse);
    });
  });
}

Map<String, String> _parseFilename(String filename) {
  final name = filename.replaceAll(RegExp(r'\.[^.]+$'), '');
  final parts = name.split(' - ');
  
  if (parts.length >= 2) {
    return {
      'artist': parts[0].trim(),
      'title': parts.sublist(1).join(' - ').trim(),
    };
  }
  
  return {
    'artist': 'Unknown Artist',
    'title': name,
  };
}

bool _isAudioFile(String path) {
  final extensions = ['.mp3', '.m4a', '.wav', '.aac', '.flac'];
  final lowerPath = path.toLowerCase();
  return extensions.any((ext) => lowerPath.endsWith(ext));
}