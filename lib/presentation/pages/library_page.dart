import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/track.dart';
import '../providers/music_library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_tile.dart';
import 'albums_page.dart';
import 'playlists_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicLibraryProvider>().loadLibrary();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MusicLibraryProvider>().loadLibrary(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Músicas'),
            Tab(text: 'Álbuns'),
            Tab(text: 'Playlists'),
          ],
        ),
      ),
      body: Consumer<MusicLibraryProvider>(
        builder: (context, library, child) {
          if (library.state == LibraryLoadingState.loading ||
              library.state == LibraryLoadingState.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (library.state == LibraryLoadingState.noPermission) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Permissão necessária', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => library.requestPermission(),
                    child: const Text('Conceder Permissão'),
                  ),
                ],
              ),
            );
          }

          if (library.state == LibraryLoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(library.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => library.loadLibrary(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar músicas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTracksTab(library),
                    const AlbumsPage(),
                    const PlaylistsPage(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTracksTab(MusicLibraryProvider library) {
    final tracks = _searchQuery.isEmpty
        ? library.tracks
        : _searchTracks(library.tracks, _searchQuery);

    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.music_off : Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'Nenhuma música encontrada'
                  : 'Nenhum resultado para "$_searchQuery"',
              style: const TextStyle(fontSize: 16),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Adicione arquivos MP3 na pasta Music',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return TrackTile(
          track: track,
          onTap: () {
            context.read<PlayerProvider>().playTrack(
              track,
              playlist: tracks,
              index: index,
            );
          },
        );
      },
    );
  }

  List<Track> _searchTracks(List<Track> tracks, String query) {
    final lowerQuery = query.toLowerCase();
    return tracks.where((track) {
      return track.title.toLowerCase().contains(lowerQuery) ||
             track.artist.toLowerCase().contains(lowerQuery) ||
             (track.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}