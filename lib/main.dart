import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/providers/player_provider.dart';
import 'presentation/pages/library_page.dart';
import 'presentation/widgets/mini_player.dart';

void main() {
  runApp(const SoniotecaApp());
}

class SoniotecaApp extends StatelessWidget {
  const SoniotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerProvider(),
      child: MaterialApp(
        title: 'Sonioteca',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LibraryPage(),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}