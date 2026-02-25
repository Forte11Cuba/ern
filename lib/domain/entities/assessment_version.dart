import '../enums/risk_category.dart';

class AssessmentVersion {
  final int? id;
  final int assessmentId;
  final int versionNumber;
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
  final DateTime changedAt;

  const AssessmentVersion({
    this.id,
    required this.assessmentId,
    required this.versionNumber,
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
    required this.changedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentVersion &&
          id == other.id &&
          assessmentId == other.assessmentId &&
          versionNumber == other.versionNumber;

  @override
  int get hashCode => Object.hash(id, assessmentId, versionNumber);
}
