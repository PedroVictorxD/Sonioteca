import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_tile.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicLibraryProvider>().loadLibrary();
    });
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
      ),
      body: Consumer<MusicLibraryProvider>(
        builder: (context, library, child) {
          switch (library.state) {
            case LibraryLoadingState.initial:
            case LibraryLoadingState.loading:
              return const Center(child: CircularProgressIndicator());
            
            case LibraryLoadingState.noPermission:
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
            
            case LibraryLoadingState.error:
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
            
            case LibraryLoadingState.loaded:
              if (library.tracks.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.music_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Nenhuma música encontrada', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Adicione arquivos MP3 na pasta Music', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: library.tracks.length,
                itemBuilder: (context, index) {
                  final track = library.tracks[index];
                  return TrackTile(
                    track: track,
                    onTap: () {
                      context.read<PlayerProvider>().playTrack(
                        track,
                        playlist: library.tracks,
                        index: index,
                      );
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}