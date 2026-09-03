// MIT License — Copyright (c) Fitness Visuals. https://fitnessvisuals.com

/// Drop-in interactive human muscle heatmap for Flutter, powered by Rive.
///
/// ```dart
/// // Once at app startup, before any Rive widget builds:
/// await RiveNative.init();
///
/// // Anywhere in your widget tree:
/// AnatomyHeatmap(
///   activeMuscles: {Muscle.pectoralisMajor, Muscle.biceps},
/// )
/// ```
///
/// The free anatomy asset is bundled with the package, so there is nothing
/// to copy into your own `assets/` folder. The paid Basic and Advanced
/// heatmaps from https://fitnessvisuals.com ship with their own integration
/// code; this widget documents the loading and data-binding pattern they
/// share.
library;

export 'package:rive/rive.dart' show Fit, RiveNative;

export 'src/anatomy_data.dart';
export 'src/anatomy_heatmap.dart';
