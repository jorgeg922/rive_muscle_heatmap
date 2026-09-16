## 0.2.0

New free anatomy asset, `human_anatomy_free_basic_v2.0.riv`: the refreshed male artwork from the paid Basic v2.0 / Advanced v3.0 heatmaps, front view, with muscle property names aligned to the paid files.

**Breaking**

- The default `artboardName` is now `'Male-Front'` (was `'Front'`). If you passed `artboardName: 'Front'` explicitly, update it.
- `Muscle.gluteusMedius` and `MuscleGroup.glutes` are gone. The v2.0 artwork draws gluteus medius on the back view, which the free asset does not include, so there is nothing on the front artboard to highlight. `Muscle` now has 18 values and `MuscleGroup` 10.
- The v1.0 asset is no longer bundled. Pin `rive_muscle_heatmap: ^0.1.0` if you need the old artwork or the front-view gluteus medius.

**Changed**

- `Muscle.rectusAbdominis.riveProperty` is now `'rectusAbdominis'` (was `'abs'`). No change on the Dart side; `Muscle.rectusAbdominis` works as before.
- Paid-pack compatibility: the artboard name and all 18 muscle property names now match the paid Basic v2.0 and Advanced v3.0 files, so code written against `Muscle` carries over when you upgrade. The paid packs still expose muscles and features this package does not know about (back view, female body shape, and on Advanced runtime colors and tap events), so use each pack's own integration to reach those.

**Added**

- A contract test that checks every `Muscle.riveProperty` and the default artboard name exist inside the bundled asset.

## 0.1.0

- Initial release.
- `AnatomyHeatmap` widget: highlight any `Set<Muscle>` on a Rive-powered anatomy silhouette.
- Free front-view anatomy asset bundled with the package; no manual asset setup.
- `Muscle` (19 muscles) and `MuscleGroup` (11 body parts) enums.
- `assetPath` and `artboardName` parameters for loading any Rive file that follows the same per-muscle `isOn` view-model contract.
- `loadingBuilder` / `errorBuilder` / `riveFactory` customization.
