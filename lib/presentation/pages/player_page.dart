import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';

class PlayerPage extends StatelessWidget {
  final Track? track;
  final bool isPlaying;
  final Duration position;
  final Duration? duration;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<Duration> onSeek;

  const PlayerPage({
    super.key,
    this.track,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproduzindo'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: track == null
          ? const Center(child: Text('Nenhuma música selecionada'))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 120,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    track!.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    track!.artist,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: (duration?.inSeconds ?? 0).toDouble(),
                    onChanged: (value) => onSeek(Duration(seconds: value.toInt())),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position)),
                      Text(_formatDuration(duration ?? Duration.zero)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 36),
                        onPressed: onPrevious,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          size: 64,
                        ),
                        onPressed: isPlaying ? onPause : onPlay,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 36),
                        onPressed: onNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}