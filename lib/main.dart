import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SoniotecaApp());
}

class SoniotecaApp extends StatelessWidget {
  const SoniotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonioteca',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('Sonioteca'),
        ),
      ),
    );
  }
}