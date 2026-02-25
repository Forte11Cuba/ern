import '../../domain/entities/reevaluation_reminder.dart';

class ReminderModel {
  static Map<String, dynamic> toMap(ReevaluationReminder reminder) {
    return {
      if (reminder.id != null) 'id': reminder.id,
      'patient_id': reminder.patientId,
      'assessment_id': reminder.assessmentId,
      'scheduled_date': reminder.scheduledDate.toIso8601String(),
      'interval_months': reminder.intervalMonths,
      'is_completed': reminder.isCompleted ? 1 : 0,
      'created_at': reminder.createdAt.toIso8601String(),
    };
  }

  static ReevaluationReminder fromMap(Map<String, dynamic> map) {
    return ReevaluationReminder(
      id: map['id'] as int?,
      patientId: map['patient_id'] as int,
      assessmentId: map['assessment_id'] as int,
      scheduledDate: DateTime.parse(map['scheduled_date'] as String),
      intervalMonths: map['interval_months'] as int,
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
