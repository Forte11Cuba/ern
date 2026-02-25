import '../../domain/entities/reevaluation_reminder.dart';
import '../database/database_helper.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  final DatabaseHelper _dbHelper;

  ReminderRepository(this._dbHelper);

  Future<int> create(ReevaluationReminder reminder) async {
    final db = await _dbHelper.database;
    return await db.insert(
        'reevaluation_reminders', ReminderModel.toMap(reminder));
  }

  Future<List<ReevaluationReminder>> getPending() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'reevaluation_reminders',
      where: 'is_completed = 0',
      orderBy: 'scheduled_date ASC',
    );
    return maps.map(ReminderModel.fromMap).toList();
  }

  Future<List<ReevaluationReminder>> getByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'reevaluation_reminders',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'scheduled_date DESC',
    );
    return maps.map(ReminderModel.fromMap).toList();
  }

  Future<List<ReevaluationReminder>> getOverdue() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'reevaluation_reminders',
      where: 'is_completed = 0 AND scheduled_date <= ?',
      whereArgs: [now],
      orderBy: 'scheduled_date ASC',
    );
    return maps.map(ReminderModel.fromMap).toList();
  }

  Future<int> markCompleted(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'reevaluation_reminders',
      {'is_completed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Cancel pending reminders for a patient (when risk category changes).
  Future<int> cancelPendingForPatient(int patientId) async {
    final db = await _dbHelper.database;
    return await db.update(
      'reevaluation_reminders',
      {'is_completed': 1},
      where: 'patient_id = ? AND is_completed = 0',
      whereArgs: [patientId],
    );
  }
}
