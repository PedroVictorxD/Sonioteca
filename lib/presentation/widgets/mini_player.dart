import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../pages/player_page.dart';
import '../theme/app_theme.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        if (player.currentTrack == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerPage(
                  track: player.currentTrack,
                  isPlaying: player.isPlaying,
                  position: player.position,
                  duration: player.duration,
                  isShuffleEnabled: player.isShuffleEnabled,
                  repeatMode: player.repeatMode,
                  onPlay: () => player.resume(),
                  onPause: () => player.pause(),
                  onNext: () => player.next(),
                  onPrevious: () => player.previous(),
                  onToggleShuffle: () => player.toggleShuffle(),
                  onToggleRepeat: () => player.toggleRepeat(),
                  onSeek: (pos) => player.seek(pos),
                ),
              ),
            );
          },
          child: Container(
            height: 64,
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildAlbumArt(player.currentTrack!.albumArt),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.currentTrack!.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        player.currentTrack!.artist,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    player.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  onPressed: () => player.isPlaying ? player.pause() : player.resume(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumArt(String? albumArtPath) {
    if (albumArtPath != null && File(albumArtPath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(albumArtPath),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54),
    );
  }
}