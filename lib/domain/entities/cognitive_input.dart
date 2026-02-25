class CognitiveInput {
  final bool hypertension;
  final bool lowCompetence;
  final bool lowEducation;
  final bool covid;
  final bool obesity;
  final bool diabetes;
  final bool weightLoss;
  final bool inactivity;
  final bool smoking;

  const CognitiveInput({
    this.hypertension = false,
    this.lowCompetence = false,
    this.lowEducation = false,
    this.covid = false,
    this.obesity = false,
    this.diabetes = false,
    this.weightLoss = false,
    this.inactivity = false,
    this.smoking = false,
  });

  CognitiveInput copyWith({
    bool? hypertension,
    bool? lowCompetence,
    bool? lowEducation,
    bool? covid,
    bool? obesity,
    bool? diabetes,
    bool? weightLoss,
    bool? inactivity,
    bool? smoking,
  }) {
    return CognitiveInput(
      hypertension: hypertension ?? this.hypertension,
      lowCompetence: lowCompetence ?? this.lowCompetence,
      lowEducation: lowEducation ?? this.lowEducation,
      covid: covid ?? this.covid,
      obesity: obesity ?? this.obesity,
      diabetes: diabetes ?? this.diabetes,
      weightLoss: weightLoss ?? this.weightLoss,
      inactivity: inactivity ?? this.inactivity,
      smoking: smoking ?? this.smoking,
    );
  }

  List<bool> get allFactors => [
        hypertension,
        lowCompetence,
        lowEducation,
        covid,
        obesity,
        diabetes,
        weightLoss,
        inactivity,
        smoking,
      ];

  int get activeFactorCount => allFactors.where((f) => f).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CognitiveInput &&
          hypertension == other.hypertension &&
          lowCompetence == other.lowCompetence &&
          lowEducation == other.lowEducation &&
          covid == other.covid &&
          obesity == other.obesity &&
          diabetes == other.diabetes &&
          weightLoss == other.weightLoss &&
          inactivity == other.inactivity &&
          smoking == other.smoking;

  @override
  int get hashCode => Object.hash(
        hypertension,
        lowCompetence,
        lowEducation,
        covid,
        obesity,
        diabetes,
        weightLoss,
        inactivity,
        smoking,
      );
}
