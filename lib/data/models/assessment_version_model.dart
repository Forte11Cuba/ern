import '../../domain/entities/assessment_version.dart';
import '../../domain/enums/risk_category.dart';

class AssessmentVersionModel {
  static Map<String, dynamic> toMap(AssessmentVersion version) {
    return {
      if (version.id != null) 'id': version.id,
      'assessment_id': version.assessmentId,
      'version_number': version.versionNumber,
      'hypertension': version.hypertension ? 1 : 0,
      'low_competence': version.lowCompetence ? 1 : 0,
      'low_education': version.lowEducation ? 1 : 0,
      'covid': version.covid ? 1 : 0,
      'obesity': version.obesity ? 1 : 0,
      'diabetes': version.diabetes ? 1 : 0,
      'weight_loss': version.weightLoss ? 1 : 0,
      'inactivity': version.inactivity ? 1 : 0,
      'smoking': version.smoking ? 1 : 0,
      'total_score': version.totalScore,
      'risk_category': version.riskCategory.name,
      'clinical_notes': version.clinicalNotes,
      'changed_at': version.changedAt.toIso8601String(),
    };
  }

  static AssessmentVersion fromMap(Map<String, dynamic> map) {
    return AssessmentVersion(
      id: map['id'] as int?,
      assessmentId: map['assessment_id'] as int,
      versionNumber: map['version_number'] as int,
      hypertension: (map['hypertension'] as int) == 1,
      lowCompetence: (map['low_competence'] as int) == 1,
      lowEducation: (map['low_education'] as int) == 1,
      covid: (map['covid'] as int) == 1,
      obesity: (map['obesity'] as int) == 1,
      diabetes: (map['diabetes'] as int) == 1,
      weightLoss: (map['weight_loss'] as int) == 1,
      inactivity: (map['inactivity'] as int) == 1,
      smoking: (map['smoking'] as int) == 1,
      totalScore: map['total_score'] as int,
      riskCategory: RiskCategory.fromString(map['risk_category'] as String),
      clinicalNotes: map['clinical_notes'] as String?,
      changedAt: DateTime.parse(map['changed_at'] as String),
    );
  }
}
