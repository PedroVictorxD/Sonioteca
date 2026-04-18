import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('should create default settings', () {
      final settings = AppSettings();
      
      expect(settings.musicFolderPath, isNull);
      expect(settings.themeMode, ThemeMode.dark);
      expect(settings.sortOption, 'title');
      expect(settings.sleepTimerMinutes, 0);
      expect(settings.isFirstLaunch, isTrue);
    });

    test('should create settings with custom values', () {
      final settings = AppSettings(
        musicFolderPath: '/storage/music',
        themeMode: ThemeMode.light,
        sortOption: 'artist',
        sleepTimerMinutes: 30,
        isFirstLaunch: false,
      );
      
      expect(settings.musicFolderPath, '/storage/music');
      expect(settings.themeMode, ThemeMode.light);
      expect(settings.sortOption, 'artist');
      expect(settings.sleepTimerMinutes, 30);
      expect(settings.isFirstLaunch, isFalse);
    });

    test('should update music folder path', () {
      final settings = AppSettings();
      final updated = settings.updateMusicFolder('/new/path');
      
      expect(updated.musicFolderPath, '/new/path');
    });

    test('should update theme mode', () {
      final settings = AppSettings();
      final updated = settings.updateTheme(ThemeMode.light);
      
      expect(updated.themeMode, ThemeMode.light);
    });

    test('should update sort option', () {
      final settings = AppSettings();
      final updated = settings.updateSortOption('album');
      
      expect(updated.sortOption, 'album');
    });

    test('should update sleep timer', () {
      final settings = AppSettings();
      final updated = settings.updateSleepTimer(45);
      
      expect(updated.sleepTimerMinutes, 45);
    });

    test('should set first launch to false', () {
      final settings = AppSettings(isFirstLaunch: true);
      final updated = settings.setFirstLaunchComplete();
      
      expect(updated.isFirstLaunch, isFalse);
    });

    test('should preserve other values when updating music folder', () {
      final settings = AppSettings(
        themeMode: ThemeMode.dark,
        sortOption: 'artist',
      );
      final updated = settings.updateMusicFolder('/new/path');
      
      expect(updated.themeMode, ThemeMode.dark);
      expect(updated.sortOption, 'artist');
    });

    test('should handle null music folder', () {
      final settings = AppSettings(musicFolderPath: null);
      expect(settings.musicFolderPath, isNull);
    });

    test('should support different sort options', () {
      final titleOption = AppSettings().updateSortOption('title');
      final artistOption = AppSettings().updateSortOption('artist');
      final albumOption = AppSettings().updateSortOption('album');
      final dateOption = AppSettings().updateSortOption('date');
      
      expect(titleOption.sortOption, 'title');
      expect(artistOption.sortOption, 'artist');
      expect(albumOption.sortOption, 'album');
      expect(dateOption.sortOption, 'date');
    });

    test('should convert to JSON', () {
      final settings = AppSettings(
        musicFolderPath: '/path',
        themeMode: ThemeMode.dark,
        sortOption: 'title',
      );
      
      final json = settings.toJson();
      
      expect(json['musicFolderPath'], '/path');
      expect(json['themeMode'], 'dark');
      expect(json['sortOption'], 'title');
    });

    test('should create from JSON', () {
      final json = {
        'musicFolderPath': '/path',
        'themeMode': 'light',
        'sortOption': 'artist',
        'sleepTimerMinutes': 15,
        'isFirstLaunch': false,
      };
      
      final settings = AppSettings.fromJson(json);
      
      expect(settings.musicFolderPath, '/path');
      expect(settings.themeMode, ThemeMode.light);
      expect(settings.sortOption, 'artist');
      expect(settings.sleepTimerMinutes, 15);
      expect(settings.isFirstLaunch, isFalse);
    });

    test('should handle empty JSON', () {
      final settings = AppSettings.fromJson({});
      
      expect(settings.musicFolderPath, isNull);
      expect(settings.themeMode, ThemeMode.dark);
    });

    test('should validate music folder path', () {
      final settings = AppSettings();
      
      expect(settings.isValidMusicFolder('/storage/music'), isTrue);
      expect(settings.isValidMusicFolder('/storage/emulated/0/Music'), isTrue);
      expect(settings.isValidMusicFolder(''), isFalse);
    });

    test('should check if theme is dark', () {
      final darkSettings = AppSettings(themeMode: ThemeMode.dark);
      final lightSettings = AppSettings(themeMode: ThemeMode.light);
      
      expect(darkSettings.isDarkMode, isTrue);
      expect(lightSettings.isDarkMode, isFalse);
    });

    test('should get display sort option', () {
      final settings = AppSettings(sortOption: 'title');
      expect(settings.displaySortOption, 'Título');
      
      final artistSettings = AppSettings(sortOption: 'artist');
      expect(artistSettings.displaySortOption, 'Artista');
      
      final albumSettings = AppSettings(sortOption: 'album');
      expect(albumSettings.displaySortOption, 'Álbum');
    });

    test('should handle sleep timer zero', () {
      final settings = AppSettings(sleepTimerMinutes: 0);
      expect(settings.hasActiveSleepTimer, isFalse);
    });

    test('should handle sleep timer active', () {
      final settings = AppSettings(sleepTimerMinutes: 30);
      expect(settings.hasActiveSleepTimer, isTrue);
    });

    test('should clear sleep timer', () {
      final settings = AppSettings(sleepTimerMinutes: 30);
      final cleared = settings.clearSleepTimer();
      
      expect(cleared.sleepTimerMinutes, 0);
    });

    test('should get available music folders', () {
      final settings = AppSettings();
      final folders = settings.availableMusicFolders;
      
      expect(folders, isA<List<String>>());
    });
  });

  group('ThemeMode', () {
    test('should have dark mode', () {
      expect(ThemeMode.dark.index, 0);
    });

    test('should have light mode', () {
      expect(ThemeMode.light.index, 1);
    });

    test('should have system mode', () {
      expect(ThemeMode.system.index, 2);
    });
  });
}

enum ThemeMode { dark, light, system }

class AppSettings {
  final String? musicFolderPath;
  final ThemeMode themeMode;
  final String sortOption;
  final int sleepTimerMinutes;
  final bool isFirstLaunch;

  AppSettings({
    this.musicFolderPath,
    this.themeMode = ThemeMode.dark,
    this.sortOption = 'title',
    this.sleepTimerMinutes = 0,
    this.isFirstLaunch = true,
  });

  AppSettings updateMusicFolder(String path) {
    return AppSettings(
      musicFolderPath: path,
      themeMode: themeMode,
      sortOption: sortOption,
      sleepTimerMinutes: sleepTimerMinutes,
      isFirstLaunch: isFirstLaunch,
    );
  }

  AppSettings updateTheme(ThemeMode mode) {
    return AppSettings(
      musicFolderPath: musicFolderPath,
      themeMode: mode,
      sortOption: sortOption,
      sleepTimerMinutes: sleepTimerMinutes,
      isFirstLaunch: isFirstLaunch,
    );
  }

  AppSettings updateSortOption(String option) {
    return AppSettings(
      musicFolderPath: musicFolderPath,
      themeMode: themeMode,
      sortOption: option,
      sleepTimerMinutes: sleepTimerMinutes,
      isFirstLaunch: isFirstLaunch,
    );
  }

  AppSettings updateSleepTimer(int minutes) {
    return AppSettings(
      musicFolderPath: musicFolderPath,
      themeMode: themeMode,
      sortOption: sortOption,
      sleepTimerMinutes: minutes,
      isFirstLaunch: isFirstLaunch,
    );
  }

  AppSettings setFirstLaunchComplete() {
    return AppSettings(
      musicFolderPath: musicFolderPath,
      themeMode: themeMode,
      sortOption: sortOption,
      sleepTimerMinutes: sleepTimerMinutes,
      isFirstLaunch: false,
    );
  }

  AppSettings clearSleepTimer() {
    return AppSettings(
      musicFolderPath: musicFolderPath,
      themeMode: themeMode,
      sortOption: sortOption,
      sleepTimerMinutes: 0,
      isFirstLaunch: isFirstLaunch,
    );
  }

  Map<String, dynamic> toJson() => {
    'musicFolderPath': musicFolderPath,
    'themeMode': themeMode.name,
    'sortOption': sortOption,
    'sleepTimerMinutes': sleepTimerMinutes,
    'isFirstLaunch': isFirstLaunch,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      musicFolderPath: json['musicFolderPath'] as String?,
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.dark,
      ),
      sortOption: json['sortOption'] as String? ?? 'title',
      sleepTimerMinutes: json['sleepTimerMinutes'] as int? ?? 0,
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get hasActiveSleepTimer => sleepTimerMinutes > 0;
  
  String get displaySortOption {
    switch (sortOption) {
      case 'title': return 'Título';
      case 'artist': return 'Artista';
      case 'album': return 'Álbum';
      case 'date': return 'Data';
      default: return 'Título';
    }
  }

  bool isValidMusicFolder(String path) {
    return path.isNotEmpty && !path.contains(' ');
  }

  List<String> get availableMusicFolders => [
    '/storage/emulated/0/Music',
    '/storage/emulated/0/Download',
    '/storage/emulated/0/DCIM',
  ];
}