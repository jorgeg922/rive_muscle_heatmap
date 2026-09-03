// MIT License — Copyright (c) Fitness Visuals. https://fitnessvisuals.com
//
// The Rive asset bundled at
// `assets/animations/human_anatomy_free_basic_v1.0.riv` is **not** MIT —
// see `LICENSE-ASSET.md` at the package root for its terms.

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'anatomy_data.dart';

/// Renders the human anatomy silhouette and highlights any subset of
/// [Muscle]s you pass it.
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
/// [activeMuscles] is a plain `Set<Muscle>`. Drive it from `setState`,
/// Riverpod, Bloc, signals, whatever. The widget diffs the set on each
/// rebuild and writes only the booleans whose state actually changed, so
/// rebuilding the parent for unrelated reasons is free.
///
/// The bundled free asset is binary on/off per muscle. The paid packs at
/// https://fitnessvisuals.com add male and female body shapes, corrected
/// muscle names, additional muscles, and (on Advanced) intensity tiers,
/// runtime theming, and tap-to-identify events. They are not a plain asset
/// swap: the paid files use updated property names that this package's
/// [Muscle] enum does not cover, so each pack ships its own Flutter
/// integration and migration notes.
class AnatomyHeatmap extends StatefulWidget {
  /// Asset key of the free anatomy file bundled with this package.
  ///
  /// This is the default for [assetPath]; you never need to declare it in
  /// your own `pubspec.yaml`.
  static const String bundledAssetPath =
      'packages/rive_muscle_heatmap/assets/animations/human_anatomy_free_basic_v1.0.riv';

  /// Muscles to highlight. Anything not in the set renders unhighlighted.
  final Set<Muscle> activeMuscles;

  /// How the artboard scales inside its parent. Defaults to [Fit.contain]
  /// so the silhouette is always fully visible.
  final Fit fit;

  /// Asset key of the `.riv` file to render. Defaults to [bundledAssetPath].
  ///
  /// Any Rive file that follows the same view-model contract works: a root
  /// view model with one nested view model per [Muscle.riveProperty], each
  /// exposing an `isOn` boolean. The paid Fitness Visuals heatmaps use
  /// updated muscle names and extra muscles, so they need their own
  /// integration rather than just a different path here.
  final String assetPath;

  /// Name of the artboard to render. The bundled asset ships a `Front`
  /// artboard.
  final String artboardName;

  /// Rive renderer to use. Defaults to `Factory.rive` (the Rive Renderer).
  /// Pass `Factory.flutter` to render through Flutter's own canvas instead.
  final Factory? riveFactory;

  /// Shown while the asset is decoding. Defaults to a small progress
  /// indicator.
  final WidgetBuilder? loadingBuilder;

  /// Shown if the asset fails to load. Defaults to a short error message.
  final WidgetBuilder? errorBuilder;

  /// Creates a muscle heatmap.
  const AnatomyHeatmap({
    super.key,
    this.activeMuscles = const {},
    this.fit = Fit.contain,
    this.assetPath = bundledAssetPath,
    this.artboardName = 'Front',
    this.riveFactory,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<AnatomyHeatmap> createState() => _AnatomyHeatmapState();
}

class _AnatomyHeatmapState extends State<AnatomyHeatmap> {
  /// Single cached [FileLoader] per asset. Decoding the `.riv` happens once
  /// per widget instance (or per [AnatomyHeatmap.assetPath] change).
  FileLoader? _fileLoader;

  /// Root view-model instance, resolved inside `onLoaded`.
  ViewModelInstance? _bodyVm;

  /// One cached boolean handle per muscle, populated once on load so toggles
  /// in [_applyMuscleStates] are cheap property writes instead of repeated
  /// view-model traversals.
  final Map<Muscle, ViewModelInstanceBoolean> _muscleProperties = {};

  @override
  void initState() {
    super.initState();
    _fileLoader = _createLoader();
  }

  FileLoader _createLoader() => FileLoader.fromAsset(
    widget.assetPath,
    riveFactory: widget.riveFactory ?? Factory.rive,
  );

  @override
  void didUpdateWidget(covariant AnatomyHeatmap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final assetChanged =
        oldWidget.assetPath != widget.assetPath ||
        oldWidget.artboardName != widget.artboardName;
    if (assetChanged) {
      _releaseRiveResources();
      _fileLoader = _createLoader();
      return; // A fresh onLoaded will re-cache handles and apply state.
    }
    if (!_sameSet(oldWidget.activeMuscles, widget.activeMuscles)) {
      _applyMuscleStates();
    }
  }

  static bool _sameSet(Set<Muscle> a, Set<Muscle> b) =>
      a.length == b.length && a.containsAll(b);

  void _cachePropertyHandles() {
    // Dispose previously-resolved handles before rebuilding the cache so a
    // re-cache doesn't leak native resources.
    for (final prop in _muscleProperties.values) {
      prop.dispose();
    }
    _muscleProperties.clear();
    final bodyVm = _bodyVm;
    if (bodyVm == null) return;
    for (final muscle in Muscle.values) {
      final nested = bodyVm.viewModel(muscle.riveProperty);
      final isOn = nested?.boolean('isOn');
      if (isOn != null) _muscleProperties[muscle] = isOn;
    }
  }

  void _applyMuscleStates() {
    if (_bodyVm == null) return;
    // Self-heal the handle cache: `onLoaded` does not fire on hot reload, so
    // if a muscle has no cached handle yet, rebuild the cache before writing.
    final hasUncachedActive = widget.activeMuscles.any(
      (m) => !_muscleProperties.containsKey(m),
    );
    if (hasUncachedActive) _cachePropertyHandles();

    for (final entry in _muscleProperties.entries) {
      entry.value.value = widget.activeMuscles.contains(entry.key);
    }
  }

  void _releaseRiveResources() {
    // Rive view-model handles hold native resources; release immediately
    // rather than waiting for GC finalizers.
    for (final prop in _muscleProperties.values) {
      prop.dispose();
    }
    _muscleProperties.clear();
    _bodyVm?.dispose();
    _bodyVm = null;
    _fileLoader?.dispose();
    _fileLoader = null;
  }

  @override
  void dispose() {
    _releaseRiveResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      // Remount when the asset or artboard changes so the new file loads.
      key: ValueKey('${widget.assetPath}#${widget.artboardName}'),
      fileLoader: _fileLoader!,
      artboardSelector: ArtboardSelector.byName(widget.artboardName),
      // `DataBind.auto()` attaches the default view-model instance to the
      // state machine, required for the per-muscle `isOn` booleans to drive
      // the visuals.
      dataBind: DataBind.auto(),
      onLoaded: (state) {
        _bodyVm = state.controller.dataBind(DataBind.auto());
        _cachePropertyHandles();
        _applyMuscleStates();
      },
      builder: (context, state) => switch (state) {
        RiveLoading() =>
          widget.loadingBuilder?.call(context) ??
              const Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
        RiveFailed() =>
          widget.errorBuilder?.call(context) ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Could not load anatomy asset',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        RiveLoaded() => RiveWidget(controller: state.controller, fit: widget.fit),
      },
    );
  }
}
