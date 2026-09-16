import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive_muscle_heatmap/rive_muscle_heatmap.dart';

/// Structural contract test against the bundled `.riv`.
///
/// Rive stores artboard and view-model property names as length-prefixed
/// byte strings, so every name the widget relies on must appear in the file
/// immediately preceded by its own length. This cannot prove the runtime
/// binds them (that needs the native Rive runtime, which a unit test does
/// not have), but it catches the exact failure mode of a renamed or dropped
/// muscle before publish.
void main() {
  late Uint8List bytes;

  setUpAll(() {
    // Inside the package's own tests the asset lives at the plain relative
    // path; the `packages/rive_muscle_heatmap/` prefix is for consumers.
    final relative = AnatomyHeatmap.bundledAssetPath.replaceFirst(
      'packages/rive_muscle_heatmap/',
      '',
    );
    bytes = File(relative).readAsBytesSync();
  });

  bool containsLengthPrefixed(String name) {
    final needle = name.codeUnits;
    for (var i = 1; i + needle.length <= bytes.length; i++) {
      if (bytes[i - 1] != needle.length) continue;
      var match = true;
      for (var j = 0; j < needle.length; j++) {
        if (bytes[i + j] != needle[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  test('bundled asset is a Rive file', () {
    expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIVE');
  });

  test('default artboard exists in the bundled asset', () {
    const widget = AnatomyHeatmap();
    expect(
      containsLengthPrefixed(widget.artboardName),
      isTrue,
      reason: 'artboard "${widget.artboardName}" not found in asset',
    );
  });

  test('every Muscle.riveProperty exists in the bundled asset', () {
    final missing = Muscle.values
        .where((m) => !containsLengthPrefixed(m.riveProperty))
        .map((m) => m.riveProperty)
        .toList();
    expect(missing, isEmpty, reason: 'not found in asset: $missing');
  });

  test('the per-muscle isOn boolean exists in the bundled asset', () {
    expect(containsLengthPrefixed('isOn'), isTrue);
  });
}
