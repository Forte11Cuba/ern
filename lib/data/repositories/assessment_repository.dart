import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/entities/assessment_version.dart';
import '../database/database_helper.dart';
import '../models/assessment_model.dart';
import '../models/assessment_version_model.dart';

class AssessmentRepository {
  final DatabaseHelper _dbHelper;

  AssessmentRepository(this._dbHelper);

  Future<int> create(CognitiveAssessment assessment) async {
    final db = await _dbHelper.database;
    return await db.insert(
        'cognitive_assessments', AssessmentModel.toMap(assessment));
  }

  Future<CognitiveAssessment?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cognitive_assessments',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return AssessmentModel.fromMap(maps.first);
  }

  Future<List<CognitiveAssessment>> getByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cognitive_assessments',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
    );
    return maps.map(AssessmentModel.fromMap).toList();
  }

  Future<CognitiveAssessment?> getLatestByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cognitive_assessments',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return AssessmentModel.fromMap(maps.first);
  }

  /// Updates an assessment, saving the previous state to assessment_versions.
  Future<int> update(CognitiveAssessment updated) async {
    final db = await _dbHelper.database;

    // Get current state before updating
    final current = await getById(updated.id!);
    if (current == null) return 0;

    return await db.transaction((txn) async {
      // Save current state as a version snapshot
      final versionSnapshot = AssessmentVersion(
        assessmentId: current.id!,
        versionNumber: current.version,
        hypertension: current.hypertension,
        lowCompetence: current.lowCompetence,
        lowEducation: current.lowEducation,
        covid: current.covid,
        obesity: current.obesity,
        diabetes: current.diabetes,
        weightLoss: current.weightLoss,
        inactivity: current.inactivity,
        smoking: current.smoking,
        totalScore: current.totalScore,
        riskCategory: current.riskCategory,
        clinicalNotes: current.clinicalNotes,
        changedAt: DateTime.now(),
      );

      await txn.insert(
          'assessment_versions', AssessmentVersionModel.toMap(versionSnapshot));

      // Update the assessment with incremented version
      final newVersion = updated.copyWith(
        version: current.version + 1,
        updatedAt: DateTime.now(),
      );

      return await txn.update(
        'cognitive_assessments',
        AssessmentModel.toMap(newVersion),
        where: 'id = ?',
        whereArgs: [updated.id],
      );
    });
  }

  // NO delete method exposed — clinical integrity

  Future<List<AssessmentVersion>> getVersionHistory(int assessmentId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'assessment_versions',
      where: 'assessment_id = ?',
      whereArgs: [assessmentId],
      orderBy: 'version_number DESC',
    );
    return maps.map(AssessmentVersionModel.fromMap).toList();
  }

  Future<List<CognitiveAssessment>> getByFilters({
    int? patientId,
    String? riskCategory,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<String>? activeFactors,
  }) async {
    final db = await _dbHelper.database;
    final where = <String>[];
    final args = <dynamic>[];

    if (patientId != null) {
      where.add('patient_id = ?');
      args.add(patientId);
    }
    if (riskCategory != null) {
      where.add('risk_category = ?');
      args.add(riskCategory);
    }
    if (dateFrom != null) {
      where.add('created_at >= ?');
      args.add(dateFrom.toIso8601String());
    }
    if (dateTo != null) {
      where.add('created_at <= ?');
      args.add(dateTo.toIso8601String());
    }
    if (activeFactors != null) {
      for (final factor in activeFactors) {
        // Map camelCase entity field names to snake_case DB column names
        final column = _camelToSnake(factor);
        where.add('$column = 1');
      }
    }

    final maps = await db.query(
      'cognitive_assessments',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'created_at DESC',
    );
    return maps.map(AssessmentModel.fromMap).toList();
  }

  Future<List<CognitiveAssessment>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cognitive_assessments',
      orderBy: 'created_at DESC',
    );
    return maps.map(AssessmentModel.fromMap).toList();
  }

  Future<int> countAll() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cognitive_assessments',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> factorFrequencies() async {
    final db = await _dbHelper.database;
    final factors = [
      'hypertension',
      'low_competence',
      'low_education',
      'covid',
      'obesity',
      'diabetes',
      'weight_loss',
      'inactivity',
      'smoking',
    ];

    final result = <String, int>{};
    for (final factor in factors) {
      final count = await db.rawQuery(
        'SELECT COUNT(*) as count FROM cognitive_assessments WHERE $factor = 1',
      );
      result[factor] = Sqflite.firstIntValue(count) ?? 0;
    }
    return result;
  }

  static String _camelToSnake(String input) {
    return input.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
