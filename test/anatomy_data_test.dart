import 'package:flutter_test/flutter_test.dart';
import 'package:rive_muscle_heatmap/rive_muscle_heatmap.dart';

void main() {
  group('Muscle', () {
    test('every muscle has a non-empty riveProperty and displayName', () {
      for (final m in Muscle.values) {
        expect(m.riveProperty, isNotEmpty, reason: '$m');
        expect(m.displayName, isNotEmpty, reason: '$m');
      }
    });

    test('riveProperty names are unique', () {
      final names = Muscle.values.map((m) => m.riveProperty).toSet();
      expect(names.length, Muscle.values.length);
    });
  });

  group('MuscleGroup', () {
    test('every muscle belongs to exactly one group', () {
      for (final m in Muscle.values) {
        final owners = MuscleGroup.values.where((g) => g.muscles.contains(m));
        expect(owners.length, 1, reason: '$m is in ${owners.length} groups');
      }
    });

    test('no group is empty', () {
      for (final g in MuscleGroup.values) {
        expect(g.muscles, isNotEmpty, reason: '$g');
        expect(g.label, isNotEmpty, reason: '$g');
      }
    });
  });

  group('AnatomyHeatmap', () {
    test('bundled asset path is a package asset key', () {
      expect(
        AnatomyHeatmap.bundledAssetPath,
        startsWith('packages/rive_muscle_heatmap/assets/'),
      );
      expect(AnatomyHeatmap.bundledAssetPath, endsWith('.riv'));
    });

    test('constructs with defaults', () {
      const widget = AnatomyHeatmap();
      expect(widget.activeMuscles, isEmpty);
      expect(widget.assetPath, AnatomyHeatmap.bundledAssetPath);
      expect(widget.artboardName, 'Male-Front');
      expect(widget.fit, Fit.contain);
    });
  });
}
