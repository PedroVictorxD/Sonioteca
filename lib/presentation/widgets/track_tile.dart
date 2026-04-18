import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../theme/app_theme.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.music_note, color: Colors.white54),
      ),
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
      trailing: const Icon(Icons.play_arrow, color: AppColors.primary),
      onTap: onTap,
    );
  }
}