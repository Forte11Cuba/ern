import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/patient.dart';
import 'database_providers.dart';

final patientsListProvider = FutureProvider<List<Patient>>((ref) async {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getAll();
});

final patientSearchProvider =
    FutureProvider.family<List<Patient>, String>((ref, query) async {
  final repo = ref.watch(patientRepositoryProvider);
  if (query.isEmpty) return repo.getAll();
  return repo.search(query);
});

final patientByIdProvider =
    FutureProvider.family<Patient?, int>((ref, id) async {
  final repo = ref.watch(patientRepositoryProvider);
  return repo.getById(id);
});
