import 'package:flutter/material.dart';
import 'package:rive_muscle_heatmap/rive_muscle_heatmap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Rive must be initialized once before any Rive widget builds.
  await RiveNative.init();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rive_muscle_heatmap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8722A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HeatmapDemo(),
    );
  }
}

class HeatmapDemo extends StatefulWidget {
  const HeatmapDemo({super.key});

  @override
  State<HeatmapDemo> createState() => _HeatmapDemoState();
}

class _HeatmapDemoState extends State<HeatmapDemo> {
  final Set<MuscleGroup> _selected = {MuscleGroup.chest, MuscleGroup.biceps};

  Set<Muscle> get _activeMuscles => {
    for (final group in _selected) ...group.muscles,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muscle heatmap')),
      body: Column(
        children: [
          // The whole integration: one widget, one Set<Muscle>.
          Expanded(child: AnatomyHeatmap(activeMuscles: _activeMuscles)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final group in MuscleGroup.values)
                  FilterChip(
                    label: Text(group.label),
                    selected: _selected.contains(group),
                    onSelected: (on) => setState(() {
                      on ? _selected.add(group) : _selected.remove(group);
                    }),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
