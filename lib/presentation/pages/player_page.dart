import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../providers/player_provider.dart';

class PlayerPage extends StatelessWidget {
  final Track? track;
  final bool isPlaying;
  final Duration position;
  final Duration? duration;
  final bool isShuffleEnabled;
  final RepeatMode repeatMode;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onToggleShuffle;
  final VoidCallback onToggleRepeat;
  final ValueChanged<Duration> onSeek;

  const PlayerPage({
    super.key,
    this.track,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration,
    this.isShuffleEnabled = false,
    this.repeatMode = RepeatMode.none,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrevious,
    required this.onToggleShuffle,
    required this.onToggleRepeat,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(track?.album ?? 'Reproduzindo'),
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
                  Expanded(
                    flex: 3,
                    child: _buildAlbumArt(),
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
                  if (track!.album != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      track!.album!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: (duration?.inSeconds ?? 0).toDouble().clamp(1, double.infinity),
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
                        icon: Icon(
                          Icons.shuffle,
                          color: isShuffleEnabled ? Colors.green : Colors.grey,
                        ),
                        onPressed: onToggleShuffle,
                      ),
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
                      IconButton(
                        icon: Icon(
                          _getRepeatIcon(),
                          color: _getRepeatColor(),
                        ),
                        onPressed: onToggleRepeat,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getRepeatIcon() {
    return switch (repeatMode) {
      RepeatMode.none => Icons.repeat,
      RepeatMode.all => Icons.repeat,
      RepeatMode.one => Icons.repeat_one,
    };
  }

  Color _getRepeatColor() {
    return switch (repeatMode) {
      RepeatMode.none => Colors.grey,
      RepeatMode.all => Colors.green,
      RepeatMode.one => Colors.green,
    };
  }

  Widget _buildAlbumArt() {
    if (track?.albumArt != null && File(track!.albumArt!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(track!.albumArt!),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.album,
          size: 120,
          color: Colors.white54,
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