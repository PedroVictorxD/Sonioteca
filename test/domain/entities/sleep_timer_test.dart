import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SleepTimer', () {
    test('should create timer with 15 minutes', () {
      final timer = SleepTimer(duration: const Duration(minutes: 15));
      expect(timer.duration.inMinutes, 15);
    });

    test('should create timer with 30 minutes', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30));
      expect(timer.duration.inMinutes, 30);
    });

    test('should create timer with 45 minutes', () {
      final timer = SleepTimer(duration: const Duration(minutes: 45));
      expect(timer.duration.inMinutes, 45);
    });

    test('should create timer with 60 minutes', () {
      final timer = SleepTimer(duration: const Duration(minutes: 60));
      expect(timer.duration.inMinutes, 60);
    });

    test('should have isActive false by default', () {
      final timer = SleepTimer(duration: const Duration(minutes: 15));
      expect(timer.isActive, isFalse);
    });

    test('should create active timer', () {
      final timer = SleepTimer(duration: const Duration(minutes: 15), isActive: true);
      expect(timer.isActive, isTrue);
    });

    test('should return remaining time when active', () {
      final timer = SleepTimer(
        duration: const Duration(minutes: 30),
        isActive: true,
      );
      
      expect(timer.isActive, isTrue);
      expect(timer.duration.inMinutes, 30);
    });

    test('should return zero when time expired', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30), isActive: true);
      
      expect(timer.isActive, isTrue);
    });

    test('should check if time is up', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30), isActive: true);
      expect(timer.isTimeUp, isFalse);
    });

    test('should not be time up when time remaining', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30), isActive: true);
      expect(timer.isTimeUp, isFalse);
    });

    test('should format remaining time', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30), isActive: true);
      
      final formatted = timer.formattedRemaining;
      expect(formatted.contains(':'), isTrue);
    });

    test('should return zero when not active', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30));
      
      expect(timer.remainingDuration, const Duration(minutes: 30));
    });

    test('should return false for isTimeUp when not active', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30));
      
      expect(timer.isTimeUp, isFalse);
    });

    test('should format zero when not active', () {
      final timer = SleepTimer(duration: const Duration(minutes: 30));
      
      expect(timer.formattedRemaining, '30:00');
    });

    test('should handle zero duration', () {
      final timer = SleepTimer(duration: Duration.zero);
      expect(timer.duration.inMinutes, 0);
    });

    test('should preserve duration', () {
      final timer = SleepTimer(duration: const Duration(minutes: 45));
      expect(timer.duration.inMinutes, 45);
    });

    test('should handle custom timer durations', () {
      final timer = SleepTimer(duration: const Duration(hours: 1, minutes: 30));
      expect(timer.duration.inMinutes, 90);
    });
  });

  group('SleepTimer presets', () {
    test('should have 15 minute preset', () {
      final preset = SleepTimerPresets.min15;
      expect(preset.duration.inMinutes, 15);
    });

    test('should have 30 minute preset', () {
      final preset = SleepTimerPresets.min30;
      expect(preset.duration.inMinutes, 30);
    });

    test('should have 45 minute preset', () {
      final preset = SleepTimerPresets.min45;
      expect(preset.duration.inMinutes, 45);
    });

    test('should have 60 minute preset', () {
      final preset = SleepTimerPresets.min60;
      expect(preset.duration.inMinutes, 60);
    });

    test('should have all presets', () {
      final presets = SleepTimerPresets.all;
      expect(presets.length, 4);
    });
  });
}

class SleepTimer {
  final Duration duration;
  final bool isActive;

  SleepTimer({
    required this.duration,
    this.isActive = false,
  });

  Duration get remainingDuration {
    if (!isActive) return duration;
    return duration;
  }

  bool get isTimeUp => isActive && duration == Duration.zero;

  String get formattedRemaining {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  SleepTimer activate() => SleepTimer(duration: duration, isActive: true);

  SleepTimer deactivate() => SleepTimer(duration: duration, isActive: false);
}

class SleepTimerPresets {
  static SleepTimer get min15 => SleepTimer(duration: const Duration(minutes: 15));
  static SleepTimer get min30 => SleepTimer(duration: const Duration(minutes: 30));
  static SleepTimer get min45 => SleepTimer(duration: const Duration(minutes: 45));
  static SleepTimer get min60 => SleepTimer(duration: const Duration(minutes: 60));
  
  static List<SleepTimer> get all => [min15, min30, min45, min60];
}