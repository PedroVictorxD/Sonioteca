import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/track.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_tile.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePlaylistDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<PlayerProvider>(
        builder: (context, player, child) {
          if (player.playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.queue_music, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Nenhuma playlist criada'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showCreatePlaylistDialog(context),
                    child: const Text('Criar Playlist'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: player.playlists.length,
            itemBuilder: (context, index) {
              final playlist = player.playlists[index];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.queue_music, color: AppColors.primary),
                ),
                title: Text(playlist.name),
                subtitle: Text('${playlist.trackCount} músicas'),
                onTap: () => _showPlaylistTracks(context, playlist),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Nome da playlist',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final playlist = Playlist(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  tracks: [],
                );
                context.read<PlayerProvider>().createPlaylist(playlist);
                Navigator.pop(context);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _showPlaylistTracks(BuildContext context, Playlist playlist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<PlayerProvider>().deletePlaylist(playlist.id);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            if (playlist.tracks.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Playlist vazia'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: playlist.tracks.length,
                  itemBuilder: (context, index) {
                    final track = playlist.tracks[index];
                    return TrackTile(
                      track: track,
                      onTap: () {
                        context.read<PlayerProvider>().playTrack(
                          track,
                          playlist: playlist.tracks,
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}