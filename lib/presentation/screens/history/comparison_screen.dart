import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/enums/risk_category.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../widgets/risk_indicator.dart';

class ComparisonScreen extends StatelessWidget {
  final Patient patient;
  final CognitiveAssessment assessmentA;
  final CognitiveAssessment assessmentB;

  const ComparisonScreen({
    super.key,
    required this.patient,
    required this.assessmentA,
    required this.assessmentB,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = AppConstants.localizedFactorLabels(l);

    // Order: older on left, newer on right
    final older = assessmentA.createdAt.isBefore(assessmentB.createdAt)
        ? assessmentA
        : assessmentB;
    final newer = assessmentA.createdAt.isBefore(assessmentB.createdAt)
        ? assessmentB
        : assessmentA;

    final scoreDiff = newer.totalScore - older.totalScore;
    final colorOlder = older.riskCategory == RiskCategory.high
        ? AppColors.highRisk
        : AppColors.lowRisk;
    final colorNewer = newer.riskCategory == RiskCategory.high
        ? AppColors.highRisk
        : AppColors.lowRisk;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.comparison),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            patient.name ?? patient.patientCode,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Score comparison header
          Row(
            children: [
              Expanded(child: _scoreCircle(context, older, colorOlder, l.previous)),
              Column(
                children: [
                  Icon(
                    scoreDiff > 0
                        ? Icons.arrow_upward
                        : scoreDiff < 0
                            ? Icons.arrow_downward
                            : Icons.remove,
                    color: scoreDiff > 0
                        ? AppColors.highRisk
                        : scoreDiff < 0
                            ? AppColors.lowRisk
                            : Theme.of(context).colorScheme.outline,
                    size: 32,
                  ),
                  Text(
                    scoreDiff > 0 ? '+$scoreDiff' : '$scoreDiff',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: scoreDiff > 0
                          ? AppColors.highRisk
                          : scoreDiff < 0
                              ? AppColors.lowRisk
                              : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              Expanded(child: _scoreCircle(context, newer, colorNewer, l.recent)),
            ],
          ),
          const SizedBox(height: 24),
          // Factor-by-factor comparison
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.factorComparison,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  // Column headers
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(l.factor,
                            style: const TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          child: Text(
                            '${older.createdAt.day}/${older.createdAt.month}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${newer.createdAt.day}/${newer.createdAt.month}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ...labels.entries.map((e) {
                    final key = e.key;
                    final label = e.value;
                    final olderVal = older.factorsMap[key]!;
                    final newerVal = newer.factorsMap[key]!;
                    final changed = olderVal != newerVal;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: changed
                          ? Colors.orange.withAlpha(15)
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(label,
                                style: TextStyle(
                                  fontWeight:
                                      changed ? FontWeight.bold : FontWeight.normal,
                                )),
                          ),
                          Expanded(
                            child: _factorIcon(context, olderVal),
                          ),
                          Expanded(
                            child: _factorIcon(context, newerVal),
                          ),
                          Expanded(
                            child: changed
                                ? Icon(
                                    newerVal
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    size: 18,
                                    color: newerVal
                                        ? AppColors.highRisk
                                        : AppColors.lowRisk,
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.summary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _summaryRow(context, l.previousAssessment,
                      '${older.createdAt.day}/${older.createdAt.month}/${older.createdAt.year}'),
                  _summaryRow(context, l.recentAssessment,
                      '${newer.createdAt.day}/${newer.createdAt.month}/${newer.createdAt.year}'),
                  _summaryRow(context, l.scoreDifference,
                      scoreDiff > 0 ? '+$scoreDiff' : '$scoreDiff'),
                  _summaryRow(
                      context,
                      l.categoryChange,
                      older.riskCategory == newer.riskCategory
                          ? l.noChange
                          : '${older.riskCategory == RiskCategory.high ? l.highRisk : l.lowRisk} -> ${newer.riskCategory == RiskCategory.high ? l.highRisk : l.lowRisk}'),
                  _summaryRow(
                      context,
                      l.modifiedFactors,
                      '${_countChanges(older, newer)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _scoreCircle(
      BuildContext context, CognitiveAssessment a, Color color, String label) {
    return Column(
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(20),
            border: Border.all(color: color, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${a.totalScore}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22, color: color),
              ),
              Text(
                '/ ${CognitiveRiskCalculator.maxScore}',
                style: TextStyle(fontSize: 10, color: color),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        RiskIndicator(category: a.riskCategory, size: 9),
        Text(
          '${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _factorIcon(BuildContext context, bool value) {
    return Center(
      child: Icon(
        value ? Icons.check_circle : Icons.cancel_outlined,
        size: 18,
        color: value
            ? AppColors.highRisk
            : Theme.of(context).colorScheme.outline.withAlpha(80),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  int _countChanges(CognitiveAssessment a, CognitiveAssessment b) {
    int count = 0;
    final mapA = a.factorsMap;
    final mapB = b.factorsMap;
    for (final key in mapA.keys) {
      if (mapA[key] != mapB[key]) count++;
    }
    return count;
  }
}
