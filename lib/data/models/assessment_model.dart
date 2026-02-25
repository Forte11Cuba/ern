import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/enums/risk_category.dart';

class AssessmentModel {
  static Map<String, dynamic> toMap(CognitiveAssessment assessment) {
    return {
      if (assessment.id != null) 'id': assessment.id,
      'patient_id': assessment.patientId,
      'hypertension': assessment.hypertension ? 1 : 0,
      'low_competence': assessment.lowCompetence ? 1 : 0,
      'low_education': assessment.lowEducation ? 1 : 0,
      'covid': assessment.covid ? 1 : 0,
      'obesity': assessment.obesity ? 1 : 0,
      'diabetes': assessment.diabetes ? 1 : 0,
      'weight_loss': assessment.weightLoss ? 1 : 0,
      'inactivity': assessment.inactivity ? 1 : 0,
      'smoking': assessment.smoking ? 1 : 0,
      'total_score': assessment.totalScore,
      'risk_category': assessment.riskCategory.name,
      'clinical_notes': assessment.clinicalNotes,
      'version': assessment.version,
      'created_at': assessment.createdAt.toIso8601String(),
      'updated_at': assessment.updatedAt?.toIso8601String(),
    };
  }

  static CognitiveAssessment fromMap(Map<String, dynamic> map) {
    return CognitiveAssessment(
      id: map['id'] as int?,
      patientId: map['patient_id'] as int,
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
      version: map['version'] as int? ?? 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
