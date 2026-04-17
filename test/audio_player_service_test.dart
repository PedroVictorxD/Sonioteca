import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sonioteca/core/services/audio_player_service.dart';
import 'package:sonioteca/domain/entities/entities.dart';
import 'audio_player_service_test.mocks.dart';

@GenerateMocks([AudioPlayer])
void main() {
  late AudioPlayerService service;
  late MockAudioPlayer mockPlayer;

  setUp(() {
    mockPlayer = MockAudioPlayer();
    service = AudioPlayerService(audioPlayer: mockPlayer);
  });

  group('AudioPlayerService', () {
    final testTrack = Track(
      id: '1',
      title: 'Test Song',
      artist: 'Test Artist',
      filePath: '/path/to/song.mp3',
      duration: const Duration(minutes: 3),
    );

    test('play - starts playing track', () async {
      when(mockPlayer.setFilePath(testTrack.filePath)).thenAnswer((_) async => Duration(minutes: 3));
      when(mockPlayer.play()).thenAnswer((_) async {});

      await service.play(testTrack);

      verify(mockPlayer.setFilePath(testTrack.filePath)).called(1);
      verify(mockPlayer.play()).called(1);
    });

    test('pause - pauses playback', () async {
      when(mockPlayer.pause()).thenAnswer((_) async {});

      await service.pause();

      verify(mockPlayer.pause()).called(1);
    });

    test('resume - resumes playback', () async {
      when(mockPlayer.play()).thenAnswer((_) async {});

      await service.resume();

      verify(mockPlayer.play()).called(1);
    });

    test('stop - stops playback', () async {
      when(mockPlayer.stop()).thenAnswer((_) async {});

      await service.stop();

      verify(mockPlayer.stop()).called(1);
    });

    test('seek - seeks to position', () async {
      when(mockPlayer.seek(any)).thenAnswer((_) async {});

      await service.seek(const Duration(seconds: 30));

      verify(mockPlayer.seek(any)).called(1);
    });

    test('setVolume - sets volume level', () async {
      when(mockPlayer.setVolume(any)).thenAnswer((_) async {});

      await service.setVolume(0.5);

      verify(mockPlayer.setVolume(0.5)).called(1);
    });

    test('currentPosition - returns current position stream', () {
      when(mockPlayer.positionStream).thenAnswer((_) => Stream.value(const Duration(seconds: 30)));

      final stream = service.currentPosition;

      expect(stream, isNotNull);
    });

    test('isPlaying - returns playing state stream', () {
      when(mockPlayer.playingStream).thenAnswer((_) => Stream.value(true));

      final stream = service.isPlaying;

      expect(stream, isNotNull);
    });

    test('currentTrack - returns current track', () {
      final track = service.currentTrack;

      expect(track, isNull);
    });
  });
}