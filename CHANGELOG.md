## 0.1.0

- Initial release.
- `AnatomyHeatmap` widget: highlight any `Set<Muscle>` on a Rive-powered anatomy silhouette.
- Free front-view anatomy asset bundled with the package; no manual asset setup.
- `Muscle` (19 muscles) and `MuscleGroup` (11 body parts) enums.
- `assetPath` and `artboardName` parameters for loading any Rive file that follows the same per-muscle `isOn` view-model contract.
- `loadingBuilder` / `errorBuilder` / `riveFactory` customization.
