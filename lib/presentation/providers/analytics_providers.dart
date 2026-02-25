import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/entities/patient.dart';
import '../../domain/enums/risk_category.dart';
import '../../core/constants/app_constants.dart';
import 'database_providers.dart';

/// Filter state for analytics
class AnalyticsFilter {
  final String? sex;
  final int? minAge;
  final int? maxAge;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const AnalyticsFilter({
    this.sex,
    this.minAge,
    this.maxAge,
    this.dateFrom,
    this.dateTo,
  });

  AnalyticsFilter copyWith({
    String? sex,
    int? minAge,
    int? maxAge,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearSex = false,
    bool clearAge = false,
    bool clearDates = false,
  }) {
    return AnalyticsFilter(
      sex: clearSex ? null : (sex ?? this.sex),
      minAge: clearAge ? null : (minAge ?? this.minAge),
      maxAge: clearAge ? null : (maxAge ?? this.maxAge),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
    );
  }

  bool get hasFilters =>
      sex != null ||
      minAge != null ||
      maxAge != null ||
      dateFrom != null ||
      dateTo != null;
}

final analyticsFilterProvider =
    StateProvider<AnalyticsFilter>((ref) => const AnalyticsFilter());

/// All data needed for analytics, pre-filtered
class AnalyticsData {
  final List<CognitiveAssessment> assessments;
  final List<Patient> patients;
  final Map<String, int> factorFrequencies;

  const AnalyticsData({
    required this.assessments,
    required this.patients,
    required this.factorFrequencies,
  });

  int get totalAssessments => assessments.length;
  int get highRiskCount =>
      assessments.where((a) => a.riskCategory == RiskCategory.high).length;
  int get lowRiskCount => totalAssessments - highRiskCount;

  double get averageScore => totalAssessments > 0
      ? assessments.map((a) => a.totalScore).reduce((a, b) => a + b) /
          totalAssessments
      : 0.0;

  /// Distribution of scores in buckets of 10
  Map<String, int> get scoreDistribution {
    final dist = <String, int>{
      '0-9': 0,
      '10-19': 0,
      '20-29': 0,
      '30-39': 0,
      '40-49': 0,
      '50-59': 0,
    };
    for (final a in assessments) {
      final bucket = (a.totalScore ~/ 10) * 10;
      final key = '$bucket-${bucket + 9}';
      dist[key] = (dist[key] ?? 0) + 1;
    }
    return dist;
  }

  /// Factor frequency as percentage
  Map<String, double> get factorPercentages {
    if (totalAssessments == 0) return {};
    return factorFrequencies.map(
      (k, v) => MapEntry(k, v / totalAssessments * 100),
    );
  }

  /// Monthly average scores for trend
  List<MonthlyAverage> get monthlyTrend {
    if (assessments.isEmpty) return [];
    final grouped = <String, List<int>>{};
    for (final a in assessments) {
      final key =
          '${a.createdAt.year}-${a.createdAt.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(a.totalScore);
    }
    final sorted = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      final parts = e.key.split('-');
      return MonthlyAverage(
        year: int.parse(parts[0]),
        month: int.parse(parts[1]),
        average: avg,
        count: e.value.length,
      );
    }).toList();
  }

  /// Most common factor combinations in high-risk patients
  List<FactorCombination> get highRiskCorrelations {
    final highRiskAssessments =
        assessments.where((a) => a.riskCategory == RiskCategory.high).toList();
    if (highRiskAssessments.isEmpty) return [];

    // Count pairs of co-occurring factors
    final pairCounts = <String, int>{};
    final factorKeys = AppConstants.factorLabels.keys.toList();

    for (final a in highRiskAssessments) {
      final active = <String>[];
      final factors = a.factorsMap;
      for (final key in factorKeys) {
        if (factors[key] == true) active.add(key);
      }
      // Generate all pairs
      for (int i = 0; i < active.length; i++) {
        for (int j = i + 1; j < active.length; j++) {
          final pair = [active[i], active[j]]..sort();
          final pairKey = pair.join('+');
          pairCounts[pairKey] = (pairCounts[pairKey] ?? 0) + 1;
        }
      }
    }

    final sorted = pairCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(10).map((e) {
      final parts = e.key.split('+');
      return FactorCombination(
        factorA: parts[0],
        factorB: parts[1],
        count: e.value,
        percentage: e.value / highRiskAssessments.length * 100,
      );
    }).toList();
  }
}

class MonthlyAverage {
  final int year;
  final int month;
  final double average;
  final int count;

  const MonthlyAverage({
    required this.year,
    required this.month,
    required this.average,
    required this.count,
  });

  String get label => '$month/$year';
}

class FactorCombination {
  final String factorA;
  final String factorB;
  final int count;
  final double percentage;

  const FactorCombination({
    required this.factorA,
    required this.factorB,
    required this.count,
    required this.percentage,
  });
}

final analyticsDataProvider = FutureProvider<AnalyticsData>((ref) async {
  final filter = ref.watch(analyticsFilterProvider);
  final assessmentRepo = ref.watch(assessmentRepositoryProvider);
  final patientRepo = ref.watch(patientRepositoryProvider);

  var patients = await patientRepo.getAll();
  var assessments = await assessmentRepo.getByFilters(
    dateFrom: filter.dateFrom,
    dateTo: filter.dateTo,
  );

  // Apply patient-level filters
  if (filter.sex != null || filter.minAge != null || filter.maxAge != null) {
    var filteredPatients = patients;
    if (filter.sex != null) {
      filteredPatients =
          filteredPatients.where((p) => p.sex == filter.sex).toList();
    }
    if (filter.minAge != null) {
      filteredPatients =
          filteredPatients.where((p) => p.age >= filter.minAge!).toList();
    }
    if (filter.maxAge != null) {
      filteredPatients =
          filteredPatients.where((p) => p.age <= filter.maxAge!).toList();
    }
    final patientIds = filteredPatients.map((p) => p.id).toSet();
    assessments =
        assessments.where((a) => patientIds.contains(a.patientId)).toList();
    patients = filteredPatients;
  }

  // Compute factor frequencies from filtered assessments
  final freqs = <String, int>{};
  final factorColumns = [
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
  for (final col in factorColumns) {
    freqs[col] = 0;
  }
  for (final a in assessments) {
    if (a.hypertension) freqs['hypertension'] = freqs['hypertension']! + 1;
    if (a.lowCompetence) freqs['low_competence'] = freqs['low_competence']! + 1;
    if (a.lowEducation) freqs['low_education'] = freqs['low_education']! + 1;
    if (a.covid) freqs['covid'] = freqs['covid']! + 1;
    if (a.obesity) freqs['obesity'] = freqs['obesity']! + 1;
    if (a.diabetes) freqs['diabetes'] = freqs['diabetes']! + 1;
    if (a.weightLoss) freqs['weight_loss'] = freqs['weight_loss']! + 1;
    if (a.inactivity) freqs['inactivity'] = freqs['inactivity']! + 1;
    if (a.smoking) freqs['smoking'] = freqs['smoking']! + 1;
  }

  return AnalyticsData(
    assessments: assessments,
    patients: patients,
    factorFrequencies: freqs,
  );
});
