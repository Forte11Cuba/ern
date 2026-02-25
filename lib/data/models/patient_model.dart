import '../../domain/entities/patient.dart';

class PatientModel {
  static Map<String, dynamic> toMap(Patient patient) {
    return {
      if (patient.id != null) 'id': patient.id,
      'patient_code': patient.patientCode,
      'name': patient.name,
      'birth_date': patient.birthDate?.toIso8601String(),
      'age': patient.age,
      'sex': patient.sex,
      'medical_record': patient.medicalRecord,
      'notes': patient.notes,
      'is_archived': patient.isArchived ? 1 : 0,
      'created_at': patient.createdAt.toIso8601String(),
      'updated_at': patient.updatedAt?.toIso8601String(),
    };
  }

  static Patient fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as int?,
      patientCode: map['patient_code'] as String,
      name: map['name'] as String?,
      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'] as String)
          : null,
      age: map['age'] as int,
      sex: map['sex'] as String?,
      medicalRecord: map['medical_record'] as String?,
      notes: map['notes'] as String?,
      isArchived: (map['is_archived'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
