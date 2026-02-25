import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_providers.dart';

class DashboardStats {
  final int totalPatients;
  final int highRiskCount;
  final int lowRiskCount;
  final int totalAssessments;

  const DashboardStats({
    required this.totalPatients,
    required this.highRiskCount,
    required this.lowRiskCount,
    required this.totalAssessments,
  });
}

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final patientRepo = ref.watch(patientRepositoryProvider);
  final assessmentRepo = ref.watch(assessmentRepositoryProvider);

  final totalPatients = await patientRepo.countAll();
  final highRisk = await patientRepo.countByRisk('high');
  final lowRisk = await patientRepo.countByRisk('low');
  final totalAssessments = await assessmentRepo.countAll();

  return DashboardStats(
    totalPatients: totalPatients,
    highRiskCount: highRisk,
    lowRiskCount: lowRisk,
    totalAssessments: totalAssessments,
  );
});
