# rive_muscle_heatmap

**A drop-in interactive human muscle heatmap for Flutter, powered by [Rive](https://rive.app).**
Pass it a `Set<Muscle>` and the silhouette lights up. The free anatomy asset is bundled, so there is nothing to copy into your project.

[![pub package](https://img.shields.io/pub/v/rive_muscle_heatmap.svg)](https://pub.dev/packages/rive_muscle_heatmap)
[![license: MIT](https://img.shields.io/badge/code-MIT-blue.svg)](LICENSE)

[![Anatomy heatmap screenshot](https://raw.githubusercontent.com/jorgeg922/flutter-rive-muscle-heatmap/main/docs/anatomy_front_screenshot.png)](https://www.fitnessvisuals.com/playground?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package)

### 👉 [Try it live in the browser](https://www.fitnessvisuals.com/playground?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package)

No install needed: tap muscles and exercises in the interactive playground, then come back here for the three-line integration.

Made by [Fitness Visuals](https://www.fitnessvisuals.com/?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package). We ship this exact widget in our own fitness app.

> **0.2.0** ships the v2.0 artwork (the same male figure as the paid packs) and aligns muscle names with the paid files. Two breaking changes: the default artboard is now `Male-Front`, and `Muscle.gluteusMedius` is gone because the v2 artwork draws it on the back view. Details in the [changelog](CHANGELOG.md).

---

## Quickstart

**1. Add the dependency**

```yaml
dependencies:
  rive_muscle_heatmap: ^0.2.0
```

**2. Initialize Rive once at startup**

```dart
import 'package:flutter/material.dart';
import 'package:rive_muscle_heatmap/rive_muscle_heatmap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init(); // before any Rive widget builds
  runApp(const MyApp());
}
```

**3. Drop in the widget**

```dart
AnatomyHeatmap(
  activeMuscles: {Muscle.pectoralisMajor, Muscle.biceps, Muscle.brachialis},
)
```

That is the whole integration. `activeMuscles` is a plain `Set<Muscle>`: drive it from `setState`, Riverpod, Bloc, signals, whatever you already use. The widget diffs the set on every rebuild and only writes the booleans that changed.

---

## API

| Parameter | Type | Default | What it does |
|---|---|---|---|
| `activeMuscles` | `Set<Muscle>` | `{}` | Muscles to highlight. |
| `fit` | `Fit` | `Fit.contain` | How the artboard scales in its parent. |
| `assetPath` | `String` | bundled free asset | Asset key of the `.riv` to render. Any file that follows the same view-model contract (one nested view model per muscle with an `isOn` boolean) works. |
| `artboardName` | `String` | `'Male-Front'` | Artboard to render. |
| `riveFactory` | `Factory?` | `Factory.rive` | Renderer. Pass `Factory.flutter` for Flutter's canvas renderer. |
| `loadingBuilder` | `WidgetBuilder?` | spinner | Widget shown while decoding. |
| `errorBuilder` | `WidgetBuilder?` | error text | Widget shown if the asset fails to load. |

### `Muscle`

Eighteen front-view muscles, each with a `displayName` for UI:
`pectoralisMajor`, `deltoidsAnterior`, `trapezius`, `sternocleidomastoid`, `biceps`, `brachialis`, `brachioradialis`, `flexorCarpiRadialis`, `extensorCarpiUlnaris`, `rectusAbdominis`, `externalObliques`, `rectusFemoris`, `vastusLateralis`, `vastusMedialis`, `sartorius`, `tibialisAnterior`, `gastrocnemius`, `soleus`.

### `MuscleGroup`

Body-part groupings (`chest`, `shoulders`, `biceps`, `quads`, ...) with a `label` and a `muscles` set, ready for chip pickers:

```dart
AnatomyHeatmap(
  activeMuscles: {...MuscleGroup.quads.muscles, ...MuscleGroup.calves.muscles},
)
```

---

## What the free asset is, and is not

The bundled `.riv` is the **male front view**: 18 muscles, one highlight color baked in at design time, each muscle on or off. No back view, no female figure, no intensity tiers, no tap events. That is enough to prototype the feature, ship a chest-and-arms demo, or judge whether the animated approach is what your app wants.

## Upgrading to the paid heatmaps

The paid packs from Fitness Visuals add the back view, male **and** female body shapes, and 11 more muscles (29 in total, including lats, triceps, glutes, hamstrings, erector spinae, and teres major). Advanced adds four runtime-settable colors driven by a 0..4 intensity input and tap-to-identify muscle events.

Since 0.2.0 the free asset uses the same artboard naming (`Male-Front`) and the same muscle property names as the paid Basic v2.0 and Advanced v3.0 files, so everything you wrote against `Muscle` carries over. What does not carry over is the enum itself: it only knows the 18 front-view muscles. To reach the back view, the female artboards, or the Advanced color and tap features, use the pack's own integration code (each pack ships Flutter, SwiftUI, Android Kotlin, and Next.js React samples with a README). `AnatomyHeatmap` stays a faithful reference for the load, data-bind, and dispose pattern; the paid Flutter sample uses the identical mechanism.

- **Basic ($30, one-time)**: front + back, male + female, 29 muscles, single highlight color.
- **Advanced ($50, one-time)**: everything in Basic, plus four runtime colors, a 0..4 state input, and tap-to-identify.

Both include a lifetime single-app commercial license and free version updates. [See the packs](https://www.fitnessvisuals.com/pricing?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package).

---

## Platforms

Everything Rive's Flutter runtime supports: iOS, Android, macOS, Windows, Linux, and web.

## Further reading

- [Muscle map libraries for Flutter, compared](https://www.fitnessvisuals.com/blog/flutter-muscle-map-libraries-compared?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package): how this package stacks up against the SVG options.
- [How to show worked muscles in a fitness app](https://www.fitnessvisuals.com/blog/how-to-show-worked-muscles-in-a-fitness-app?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package): requirements checklist and the data layer you still need.

## License

- **Dart code**: MIT, see [LICENSE](LICENSE).
- **Bundled `.riv` asset**: free to use in personal and commercial apps, no modification or standalone redistribution, see [LICENSE-ASSET.md](LICENSE-ASSET.md).
