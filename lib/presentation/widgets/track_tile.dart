import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../theme/app_theme.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToQueue;

  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onAddToQueue,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAlbumArt(),
      title: Text(
        track.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist,
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onFavoriteToggle != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          if (onAddToQueue != null)
            IconButton(
              icon: const Icon(Icons.queue_music, color: Colors.grey),
              onPressed: onAddToQueue,
            ),
          const Icon(Icons.play_arrow, color: AppColors.primary),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildAlbumArt() {
    if (track.albumArt != null && File(track.albumArt!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(track.albumArt!),
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
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54),
    );
  }
}