class ReevaluationReminder {
  final int? id;
  final int patientId;
  final int assessmentId;
  final DateTime scheduledDate;
  final int intervalMonths;
  final bool isCompleted;
  final DateTime createdAt;

  const ReevaluationReminder({
    this.id,
    required this.patientId,
    required this.assessmentId,
    required this.scheduledDate,
    required this.intervalMonths,
    this.isCompleted = false,
    required this.createdAt,
  });

  ReevaluationReminder copyWith({
    int? id,
    int? patientId,
    int? assessmentId,
    DateTime? scheduledDate,
    int? intervalMonths,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return ReevaluationReminder(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      assessmentId: assessmentId ?? this.assessmentId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReevaluationReminder && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
