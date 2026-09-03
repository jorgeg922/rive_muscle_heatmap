# rive_muscle_heatmap

**A drop-in interactive human muscle heatmap for Flutter, powered by [Rive](https://rive.app).**
Pass it a `Set<Muscle>` and the silhouette lights up. The free anatomy asset is bundled, so there is nothing to copy into your project.

[![pub package](https://img.shields.io/pub/v/rive_muscle_heatmap.svg)](https://pub.dev/packages/rive_muscle_heatmap)
[![license: MIT](https://img.shields.io/badge/code-MIT-blue.svg)](LICENSE)

[![Anatomy heatmap screenshot](https://raw.githubusercontent.com/jorgeg922/flutter-rive-muscle-heatmap/main/docs/anatomy_front_screenshot.png)](https://www.fitnessvisuals.com/playground?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package)

### 👉 [Try it live in the browser](https://www.fitnessvisuals.com/playground?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package)

No install needed: tap muscles and exercises in the interactive playground, then come back here for the three-line integration.

Made by [Fitness Visuals](https://www.fitnessvisuals.com/?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package). We ship this exact widget in our own fitness app.

---

## Quickstart

**1. Add the dependency**

```yaml
dependencies:
  rive_muscle_heatmap: ^0.1.0
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
| `artboardName` | `String` | `'Front'` | Artboard to render. |
| `riveFactory` | `Factory?` | `Factory.rive` | Renderer. Pass `Factory.flutter` for Flutter's canvas renderer. |
| `loadingBuilder` | `WidgetBuilder?` | spinner | Widget shown while decoding. |
| `errorBuilder` | `WidgetBuilder?` | error text | Widget shown if the asset fails to load. |

### `Muscle`

Nineteen front-view muscles, each with a `displayName` for UI:
`pectoralisMajor`, `deltoidsAnterior`, `trapezius`, `sternocleidomastoid`, `biceps`, `brachialis`, `brachioradialis`, `flexorCarpiRadialis`, `extensorCarpiUlnaris`, `rectusAbdominis`, `externalObliques`, `rectusFemoris`, `vastusLateralis`, `vastusMedialis`, `sartorius`, `gluteusMedius`, `tibialisAnterior`, `gastrocnemius`, `soleus`.

### `MuscleGroup`

Body-part groupings (`chest`, `shoulders`, `biceps`, `quads`, ...) with a `label` and a `muscles` set, ready for chip pickers:

```dart
AnatomyHeatmap(
  activeMuscles: {...MuscleGroup.quads.muscles, ...MuscleGroup.calves.muscles},
)
```

---

## Upgrading to the paid heatmaps

The bundled asset is the free single-color, front-view heatmap. The paid packs from Fitness Visuals add the back view, male **and** female body shapes, corrected anatomical naming, additional muscles (teres major, for example), and on Advanced, intensity tiers, four runtime-settable colors, and tap-to-identify muscle events.

Be aware that this is **not a plain asset swap**. The paid files use updated muscle property names and expose muscles this package's `Muscle` enum does not know about, so they ship with their own Flutter integration code and a migration README covering the breaking changes. Plan the upgrade as adopting the pack's integration, with this package's `AnatomyHeatmap` as the reference for the loading, data-binding, and disposal pattern (it is the same mechanism).

- **Basic ($30, one-time)**: single highlight color, male + female shapes.
- **Advanced ($50, one-time)**: four runtime colors driven by a state input, click-to-identify muscles, male + female shapes.

Both include a lifetime single-app commercial license and integration samples for Flutter, SwiftUI, Android, and React. [See the packs](https://www.fitnessvisuals.com/pricing?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package).

---

## Platforms

Everything Rive's Flutter runtime supports: iOS, Android, macOS, Windows, Linux, and web.

## Further reading

- [Muscle map libraries for Flutter, compared](https://www.fitnessvisuals.com/blog/flutter-muscle-map-libraries-compared?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package): how this package stacks up against the SVG options.
- [How to show worked muscles in a fitness app](https://www.fitnessvisuals.com/blog/how-to-show-worked-muscles-in-a-fitness-app?utm_source=pub_dev&utm_medium=referral&utm_campaign=flutter-package): requirements checklist and the data layer you still need.

## License

- **Dart code**: MIT, see [LICENSE](LICENSE).
- **Bundled `.riv` asset**: free to use in personal and commercial apps, no modification or standalone redistribution, see [LICENSE-ASSET.md](LICENSE-ASSET.md).
