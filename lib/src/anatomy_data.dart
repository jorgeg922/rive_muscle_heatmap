// MIT License — Copyright (c) Fitness Visuals. https://fitnessvisuals.com

/// Every muscle the bundled `human_anatomy_free_basic_v1.0.riv` asset can
/// highlight. This enum is the public contract of `AnatomyHeatmap`: pass any
/// subset of these values via `activeMuscles` and they light up.
///
/// [riveProperty] is the exact view-model property name the bundled free
/// asset expects. The widget maps `Muscle` to `riveProperty` internally so
/// callers never deal with stringly-typed names. The paid Fitness Visuals
/// heatmaps use corrected names and additional muscles not listed here.
enum Muscle {
  /// Chest.
  pectoralisMajor('pectoralisMajor', 'Pectoralis Major'),

  /// Front of the shoulder.
  deltoidsAnterior('deltoids', 'Anterior Deltoid'),

  /// Upper back and neck.
  trapezius('trapezius', 'Trapezius'),

  /// Side of the neck.
  sternocleidomastoid('sternocleidomastoid', 'Sternocleidomastoid'),

  /// Front of the upper arm.
  biceps('biceps', 'Biceps Brachii'),

  /// Deep elbow flexor beneath the biceps.
  brachialis('brachialis', 'Brachialis'),

  /// Thumb side of the forearm.
  brachioradialis('brachioradialis', 'Brachioradialis'),

  /// Inner forearm wrist flexor.
  flexorCarpiRadialis('flexorCarpiRadialis', 'Flexor Carpi Radialis'),

  /// Outer forearm wrist extensor.
  extensorCarpiUlnaris('extensorCarpiUlnaris', 'Extensor Carpi Ulnaris'),

  /// Abs.
  rectusAbdominis('abs', 'Rectus Abdominis'),

  /// Side abs.
  externalObliques('externalObliques', 'External Obliques'),

  /// Central quad.
  rectusFemoris('rectusFemoris', 'Rectus Femoris'),

  /// Outer quad.
  vastusLateralis('vastusLateralis', 'Vastus Lateralis'),

  /// Inner quad (teardrop).
  vastusMedialis('vastusMedialis', 'Vastus Medialis'),

  /// Long strap muscle across the thigh.
  sartorius('sartorius', 'Sartorius'),

  /// Side of the hip.
  gluteusMedius('gluteusMedius', 'Gluteus Medius'),

  /// Front of the shin.
  tibialisAnterior('tibialisAnterior', 'Tibialis Anterior'),

  /// Upper calf.
  gastrocnemius('gastrocnemius', 'Gastrocnemius'),

  /// Deep lower calf.
  soleus('soleus', 'Soleus');

  const Muscle(this.riveProperty, this.displayName);

  /// The nested view-model name on the asset's root view model.
  final String riveProperty;

  /// Human-readable label for UI.
  final String displayName;
}

/// User-facing groupings of [Muscle]s, the "body part" a fitness app would
/// surface in a filter or chip picker. Not required by `AnatomyHeatmap`,
/// which only cares about individual muscles, but handy for building UI.
enum MuscleGroup {
  /// Chest.
  chest('Chest', {Muscle.pectoralisMajor}),

  /// Shoulders.
  shoulders('Shoulders', {Muscle.deltoidsAnterior}),

  /// Traps.
  traps('Traps', {Muscle.trapezius}),

  /// Neck.
  neck('Neck', {Muscle.sternocleidomastoid}),

  /// Biceps and the brachialis beneath them.
  biceps('Biceps', {Muscle.biceps, Muscle.brachialis}),

  /// Forearms.
  forearms('Forearms', {
    Muscle.brachioradialis,
    Muscle.flexorCarpiRadialis,
    Muscle.extensorCarpiUlnaris,
  }),

  /// Abs.
  abs('Abs', {Muscle.rectusAbdominis}),

  /// Obliques.
  obliques('Obliques', {Muscle.externalObliques}),

  /// Quads.
  quads('Quads', {
    Muscle.rectusFemoris,
    Muscle.vastusLateralis,
    Muscle.vastusMedialis,
    Muscle.sartorius,
  }),

  /// Glutes (front-view portion).
  glutes('Glutes', {Muscle.gluteusMedius}),

  /// Calves and shins.
  calves('Calves', {
    Muscle.gastrocnemius,
    Muscle.soleus,
    Muscle.tibialisAnterior,
  });

  const MuscleGroup(this.label, this.muscles);

  /// Human-readable label for UI.
  final String label;

  /// The muscles that make up this group.
  final Set<Muscle> muscles;
}
