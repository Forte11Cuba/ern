import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../domain/entities/patient.dart';
import '../database/database_helper.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final DatabaseHelper _dbHelper;

  PatientRepository(this._dbHelper);

  Future<int> create(Patient patient) async {
    final db = await _dbHelper.database;
    return await db.insert('patients', PatientModel.toMap(patient));
  }

  Future<Patient?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'patients',
      where: 'id = ? AND is_archived = 0',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return PatientModel.fromMap(maps.first);
  }

  Future<Patient?> getByCode(String code) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'patients',
      where: 'patient_code = ? AND is_archived = 0',
      whereArgs: [code],
    );
    if (maps.isEmpty) return null;
    return PatientModel.fromMap(maps.first);
  }

  Future<List<Patient>> getAll({bool includeArchived = false}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'patients',
      where: includeArchived ? null : 'is_archived = 0',
      orderBy: 'created_at DESC',
    );
    return maps.map(PatientModel.fromMap).toList();
  }

  Future<List<Patient>> search(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'patients',
      where:
          'is_archived = 0 AND (patient_code LIKE ? OR name LIKE ? OR medical_record LIKE ?)',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return maps.map(PatientModel.fromMap).toList();
  }

  Future<int> update(Patient patient) async {
    final db = await _dbHelper.database;
    final updatedPatient = patient.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'patients',
      PatientModel.toMap(updatedPatient),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  /// Soft-delete: archives the patient instead of deleting.
  Future<int> archive(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'patients',
      {
        'is_archived': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> countAll() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM patients WHERE is_archived = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countByRisk(String riskCategory) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT p.id) as count
      FROM patients p
      INNER JOIN cognitive_assessments ca ON p.id = ca.patient_id
      WHERE p.is_archived = 0
        AND ca.id = (
          SELECT id FROM cognitive_assessments
          WHERE patient_id = p.id
          ORDER BY created_at DESC LIMIT 1
        )
        AND ca.risk_category = ?
    ''', [riskCategory]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
