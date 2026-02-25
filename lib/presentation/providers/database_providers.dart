import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/database_helper.dart';
import '../../data/repositories/patient_repository.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/reminder_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

/// Initializes the database and checks onboarding state.
/// Returns true if onboarding was already seen.
final appInitProvider = FutureProvider<bool>((ref) async {
  final dbHelper = ref.read(databaseHelperProvider);
  await dbHelper.database;
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_seen_onboarding') ?? false;
});

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepository(ref.watch(databaseHelperProvider));
});

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(ref.watch(databaseHelperProvider));
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(databaseHelperProvider));
});
