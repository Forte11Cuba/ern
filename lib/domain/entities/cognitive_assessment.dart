import '../enums/risk_category.dart';

class CognitiveAssessment {
  final int? id;
  final int patientId;
  final bool hypertension;
  final bool lowCompetence;
  final bool lowEducation;
  final bool covid;
  final bool obesity;
  final bool diabetes;
  final bool weightLoss;
  final bool inactivity;
  final bool smoking;
  final int totalScore;
  final RiskCategory riskCategory;
  final String? clinicalNotes;
  final int version;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CognitiveAssessment({
    this.id,
    required this.patientId,
    required this.hypertension,
    required this.lowCompetence,
    required this.lowEducation,
    required this.covid,
    required this.obesity,
    required this.diabetes,
    required this.weightLoss,
    required this.inactivity,
    required this.smoking,
    required this.totalScore,
    required this.riskCategory,
    this.clinicalNotes,
    this.version = 1,
    required this.createdAt,
    this.updatedAt,
  });

  CognitiveAssessment copyWith({
    int? id,
    int? patientId,
    bool? hypertension,
    bool? lowCompetence,
    bool? lowEducation,
    bool? covid,
    bool? obesity,
    bool? diabetes,
    bool? weightLoss,
    bool? inactivity,
    bool? smoking,
    int? totalScore,
    RiskCategory? riskCategory,
    String? clinicalNotes,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CognitiveAssessment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      hypertension: hypertension ?? this.hypertension,
      lowCompetence: lowCompetence ?? this.lowCompetence,
      lowEducation: lowEducation ?? this.lowEducation,
      covid: covid ?? this.covid,
      obesity: obesity ?? this.obesity,
      diabetes: diabetes ?? this.diabetes,
      weightLoss: weightLoss ?? this.weightLoss,
      inactivity: inactivity ?? this.inactivity,
      smoking: smoking ?? this.smoking,
      totalScore: totalScore ?? this.totalScore,
      riskCategory: riskCategory ?? this.riskCategory,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, bool> get factorsMap => {
        'hypertension': hypertension,
        'lowCompetence': lowCompetence,
        'lowEducation': lowEducation,
        'covid': covid,
        'obesity': obesity,
        'diabetes': diabetes,
        'weightLoss': weightLoss,
        'inactivity': inactivity,
        'smoking': smoking,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CognitiveAssessment && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
