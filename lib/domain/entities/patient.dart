class Patient {
  final int? id;
  final String patientCode;
  final String? name;
  final DateTime? birthDate;
  final int age;
  final String? sex;
  final String? medicalRecord;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Patient({
    this.id,
    required this.patientCode,
    this.name,
    this.birthDate,
    required this.age,
    this.sex,
    this.medicalRecord,
    this.notes,
    this.isArchived = false,
    required this.createdAt,
    this.updatedAt,
  });

  Patient copyWith({
    int? id,
    String? patientCode,
    String? name,
    DateTime? birthDate,
    int? age,
    String? sex,
    String? medicalRecord,
    String? notes,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      patientCode: patientCode ?? this.patientCode,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      medicalRecord: medicalRecord ?? this.medicalRecord,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Patient &&
          id == other.id &&
          patientCode == other.patientCode;

  @override
  int get hashCode => Object.hash(id, patientCode);
}
