import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equalizer', () {
    test('should create equalizer with default bands', () {
      final eq = Equalizer();
      
      expect(eq.bands.length, 10);
      expect(eq.isEnabled, isFalse);
    });

    test('should create equalizer with custom bands', () {
      final eq = Equalizer(bands: [
        EqualizerBand(frequency: 60, gain: 0),
        EqualizerBand(frequency: 170, gain: 0),
        EqualizerBand(frequency: 310, gain: 0),
      ]);
      
      expect(eq.bands.length, 3);
    });

    test('should enable equalizer', () {
      final eq = Equalizer();
      final enabled = eq.enable();
      
      expect(enabled.isEnabled, isTrue);
    });

    test('should disable equalizer', () {
      final eq = Equalizer(isEnabled: true);
      final disabled = eq.disable();
      
      expect(disabled.isEnabled, isFalse);
    });

    test('should toggle equalizer', () {
      final eq = Equalizer();
      final toggled = eq.toggle();
      
      expect(toggled.isEnabled, isTrue);
      
      final toggledAgain = toggled.toggle();
      expect(toggledAgain.isEnabled, isFalse);
    });

    test('should set band gain', () {
      final eq = Equalizer();
      final updated = eq.setBandGain(60, 5.0);
      
      expect(updated.bands.first.gain, 5.0);
    });

    test('should reset all bands', () {
      final eq = Equalizer(bands: [
        EqualizerBand(frequency: 60, gain: 5),
        EqualizerBand(frequency: 170, gain: 3),
      ]);
      final reset = eq.reset();
      
      expect(reset.bands[0].gain, 0);
      expect(reset.bands[1].gain, 0);
    });

    test('should apply preset', () {
      final eq = Equalizer();
      final preset = eq.applyPreset(EqualizerPreset.rock);
      
      expect(preset.isEnabled, isTrue);
    });

    test('should get preset names', () {
      final presets = EqualizerPreset.values;
      
      expect(presets.length, greaterThan(0));
    });

    test('should apply flat preset', () {
      final eq = Equalizer();
      final flat = eq.applyPreset(EqualizerPreset.flat);
      
      expect(flat.bands.every((b) => b.gain == 0), isTrue);
    });

    test('should apply bass boost preset', () {
      final eq = Equalizer();
      final boosted = eq.applyPreset(EqualizerPreset.bassBoost);
      
      expect(boosted.bands.first.gain, greaterThan(0));
    });

    test('should apply treble boost preset', () {
      final eq = Equalizer();
      final boosted = eq.applyPreset(EqualizerPreset.trebleBoost);
      
      expect(boosted.bands.last.gain, greaterThan(0));
    });

    test('should apply vocal preset', () {
      final eq = Equalizer();
      final vocal = eq.applyPreset(EqualizerPreset.vocal);
      
      expect(vocal.isEnabled, isTrue);
    });

    test('should apply electronic preset', () {
      final eq = Equalizer();
      final electronic = eq.applyPreset(EqualizerPreset.electronic);
      
      expect(electronic.isEnabled, isTrue);
    });

    test('should apply classical preset', () {
      final eq = Equalizer();
      final classical = eq.applyPreset(EqualizerPreset.classical);
      
      expect(classical.isEnabled, isTrue);
    });

    test('should get band by frequency', () {
      final eq = Equalizer(bands: [
        EqualizerBand(frequency: 60, gain: 0),
        EqualizerBand(frequency: 170, gain: 0),
      ]);
      
      final band = eq.getBand(60);
      expect(band?.frequency, 60);
    });

    test('should return null for non-existent frequency', () {
      final eq = Equalizer(bands: [
        EqualizerBand(frequency: 60, gain: 0),
      ]);
      
      final band = eq.getBand(999);
      expect(band, isNull);
    });

    test('should clamp gain values', () {
      final eq = Equalizer();
      final updated = eq.setBandGain(60, 20.0);
      
      expect(updated.bands.first.gain, lessThanOrEqualTo(12));
    });

    test('should clamp negative gain values', () {
      final eq = Equalizer();
      final updated = eq.setBandGain(60, -20.0);
      
      expect(updated.bands.first.gain, greaterThanOrEqualTo(-12));
    });

    test('should serialize to JSON', () {
      final eq = Equalizer(isEnabled: true, bands: [
        EqualizerBand(frequency: 60, gain: 5),
      ]);
      
      final json = eq.toJson();
      
      expect(json['isEnabled'], isTrue);
      expect(json['bands'], isA<List>());
    });

    test('should deserialize from JSON', () {
      final json = {
        'isEnabled': true,
        'bands': [
          {'frequency': 60, 'gain': 5.0},
        ],
      };
      
      final eq = Equalizer.fromJson(json);
      
      expect(eq.isEnabled, isTrue);
      expect(eq.bands.first.frequency, 60);
    });

    test('should handle empty JSON', () {
      final eq = Equalizer.fromJson({});
      
      expect(eq.isEnabled, isFalse);
    });

    test('should get max gain', () {
      final eq = Equalizer();
      
      expect(eq.maxGain, 12.0);
    });

    test('should get min gain', () {
      final eq = Equalizer();
      
      expect(eq.minGain, -12.0);
    });

    test('should copy equalizer with modifications', () {
      final eq = Equalizer(bands: [EqualizerBand(frequency: 60, gain: 5)]);
      final copied = eq.copyWith(isEnabled: true);
      
      expect(copied.isEnabled, isTrue);
      expect(copied.bands.first.gain, 5);
    });

    test('should validate gain range', () {
      final eq = Equalizer();
      
      expect(eq.isValidGain(0), isTrue);
      expect(eq.isValidGain(12), isTrue);
      expect(eq.isValidGain(-12), isTrue);
      expect(eq.isValidGain(13), isFalse);
      expect(eq.isValidGain(-13), isFalse);
    });
  });

  group('EqualizerBand', () {
    test('should create band with frequency and gain', () {
      final band = EqualizerBand(frequency: 1000, gain: 5.0);
      
      expect(band.frequency, 1000);
      expect(band.gain, 5.0);
    });

    test('should format frequency', () {
      final band = EqualizerBand(frequency: 1000, gain: 0);
      
      expect(band.formattedFrequency, '1 kHz');
    });

    test('should format low frequency', () {
      final band = EqualizerBand(frequency: 60, gain: 0);
      
      expect(band.formattedFrequency, '60 Hz');
    });

    test('should format high frequency', () {
      final band = EqualizerBand(frequency: 14000, gain: 0);
      
      expect(band.formattedFrequency, '14 kHz');
    });
  });
}

class EqualizerBand {
  final int frequency;
  final double gain;

  EqualizerBand({required this.frequency, this.gain = 0});

  String get formattedFrequency {
    if (frequency >= 1000) {
      return '${frequency ~/ 1000} kHz';
    }
    return '$frequency Hz';
  }
}

enum EqualizerPreset { flat, rock, pop, jazz, classical, bassBoost, trebleBoost, vocal, electronic }

class Equalizer {
  final bool isEnabled;
  final List<EqualizerBand> bands;

  Equalizer({
    this.isEnabled = false,
    List<EqualizerBand>? bands,
  }) : bands = bands ?? _defaultBands();

  static List<EqualizerBand> _defaultBands() {
    return [
      EqualizerBand(frequency: 60, gain: 0),
      EqualizerBand(frequency: 170, gain: 0),
      EqualizerBand(frequency: 310, gain: 0),
      EqualizerBand(frequency: 600, gain: 0),
      EqualizerBand(frequency: 1000, gain: 0),
      EqualizerBand(frequency: 3000, gain: 0),
      EqualizerBand(frequency: 6000, gain: 0),
      EqualizerBand(frequency: 12000, gain: 0),
      EqualizerBand(frequency: 14000, gain: 0),
      EqualizerBand(frequency: 16000, gain: 0),
    ];
  }

  Equalizer enable() => Equalizer(isEnabled: true, bands: bands);
  Equalizer disable() => Equalizer(isEnabled: false, bands: bands);
  Equalizer toggle() => Equalizer(isEnabled: !isEnabled, bands: bands);

  Equalizer setBandGain(int frequency, double gain) {
    final clampedGain = gain.clamp(-12.0, 12.0);
    final newBands = bands.map((b) {
      if (b.frequency == frequency) {
        return EqualizerBand(frequency: b.frequency, gain: clampedGain);
      }
      return b;
    }).toList();
    return Equalizer(isEnabled: isEnabled, bands: newBands);
  }

  EqualizerBand? getBand(int frequency) {
    try {
      return bands.firstWhere((b) => b.frequency == frequency);
    } catch (_) {
      return null;
    }
  }

  Equalizer reset() {
    final resetBands = bands.map((b) => EqualizerBand(frequency: b.frequency, gain: 0)).toList();
    return Equalizer(isEnabled: isEnabled, bands: resetBands);
  }

  Equalizer applyPreset(EqualizerPreset preset) {
    final gains = _getPresetGains(preset);
    final newBands = <EqualizerBand>[];
    
    for (var i = 0; i < bands.length; i++) {
      final gain = i < gains.length ? gains[i] : 0.0;
      newBands.add(EqualizerBand(frequency: bands[i].frequency, gain: gain));
    }
    
    return Equalizer(isEnabled: true, bands: newBands);
  }

  List<double> _getPresetGains(EqualizerPreset preset) {
    switch (preset) {
      case EqualizerPreset.flat:
        return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      case EqualizerPreset.rock:
        return [5, 4, 2, 0, -1, 0, 2, 4, 5, 5];
      case EqualizerPreset.pop:
        return [-1, 0, 2, 4, 5, 4, 2, 0, -1, -2];
      case EqualizerPreset.jazz:
        return [3, 2, 1, 2, -2, -2, 0, 2, 3, 4];
      case EqualizerPreset.classical:
        return [4, 3, 2, 1, -1, -1, 0, 2, 3, 4];
      case EqualizerPreset.bassBoost:
        return [6, 5, 4, 2, 0, 0, 0, 0, 0, 0];
      case EqualizerPreset.trebleBoost:
        return [0, 0, 0, 0, 0, 2, 4, 5, 6, 6];
      case EqualizerPreset.vocal:
        return [-2, -1, 0, 2, 4, 4, 2, 0, -1, -2];
      case EqualizerPreset.electronic:
        return [4, 3, 0, -2, -3, 0, 2, 4, 5, 5];
    }
  }

  double get maxGain => 12.0;
  double get minGain => -12.0;

  bool isValidGain(double gain) => gain >= -12.0 && gain <= 12.0;

  Equalizer copyWith({bool? isEnabled, List<EqualizerBand>? bands}) {
    return Equalizer(
      isEnabled: isEnabled ?? this.isEnabled,
      bands: bands ?? this.bands,
    );
  }

  Map<String, dynamic> toJson() => {
    'isEnabled': isEnabled,
    'bands': bands.map((b) => {'frequency': b.frequency, 'gain': b.gain}).toList(),
  };

  factory Equalizer.fromJson(Map<String, dynamic> json) {
    final bandsJson = json['bands'] as List? ?? [];
    final bands = bandsJson.map((b) => EqualizerBand(
      frequency: b['frequency'] as int,
      gain: (b['gain'] as num).toDouble(),
    )).toList();
    return Equalizer(
      isEnabled: json['isEnabled'] as bool? ?? false,
      bands: bands.isEmpty ? null : bands,
    );
  }
}