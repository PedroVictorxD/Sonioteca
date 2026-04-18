import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/track.dart';
import '../providers/music_library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_tile.dart';

class Album {
  final String name;
  final String? coverPath;
  final List<Track> tracks;

  Album({
    required this.name,
    this.coverPath,
    required this.tracks,
  });
}

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Álbuns'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<MusicLibraryProvider>(
        builder: (context, library, child) {
          if (library.state != LibraryLoadingState.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final albums = _groupAlbums(library.tracks);
          
          if (albums.isEmpty) {
            return const Center(
              child: Text('Nenhum álbum encontrado'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return _AlbumCard(
                album: album,
                onTap: () => _showAlbumTracks(context, album),
              );
            },
          );
        },
      ),
    );
  }

  List<Album> _groupAlbums(List<Track> tracks) {
    final map = <String, Album>{};
    for (final track in tracks) {
      final albumName = track.album ?? 'Unknown Album';
      if (!map.containsKey(albumName)) {
        map[albumName] = Album(
          name: albumName,
          coverPath: track.albumArt,
          tracks: [],
        );
      }
      map[albumName]!.tracks.add(track);
    }
    return map.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  void _showAlbumTracks(BuildContext context, Album album) {
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
                      album.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${album.tracks.length} músicas',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: album.tracks.length,
                itemBuilder: (context, index) {
                  final track = album.tracks[index];
                  return TrackTile(
                    track: track,
                    onTap: () {
                      context.read<PlayerProvider>().playTrack(
                        track,
                        playlist: album.tracks,
                        index: index,
                      );
                      Navigator.pop(context);
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

class _AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const _AlbumCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: album.coverPath != null && File(album.coverPath!).existsSync()
                  ? Image.file(
                      File(album.coverPath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            album.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${album.tracks.length} músicas',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.album, size: 48, color: Colors.white54),
      ),
    );
  }
}