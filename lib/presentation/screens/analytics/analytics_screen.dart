import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../providers/analytics_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(analyticsDataProvider);
    final filter = ref.watch(analyticsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.analytics),
        actions: [
          if (filter.hasFilters)
            TextButton(
              onPressed: () {
                ref.read(analyticsFilterProvider.notifier).state =
                    const AnalyticsFilter();
              },
              child: Text(l.clearFilters),
            ),
        ],
      ),
      body: dataAsync.when(
        data: (data) {
          if (data.totalAssessments == 0) {
            return Center(child: Text(l.noAssessmentsToShow));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _FiltersBar(),
              const SizedBox(height: 16),
              _SummaryRow(data: data),
              const SizedBox(height: 20),
              _SectionTitle(title: l.scoreDistribution),
              const SizedBox(height: 8),
              _ScoreDistributionChart(data: data),
              const SizedBox(height: 24),
              _SectionTitle(title: l.mostFrequentFactors),
              const SizedBox(height: 8),
              _FactorFrequencyChart(data: data),
              const SizedBox(height: 24),
              if (data.monthlyTrend.length >= 2) ...[
                _SectionTitle(title: l.temporalTrend),
                const SizedBox(height: 8),
                _TrendChart(data: data),
                const SizedBox(height: 24),
              ],
              if (data.highRiskCorrelations.isNotEmpty) ...[
                _SectionTitle(title: l.factorCorrelation),
                const SizedBox(height: 8),
                _CorrelationTable(data: data),
              ],
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l.error}: $e')),
      ),
    );
  }
}

class _FiltersBar extends ConsumerWidget {
  const _FiltersBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final filter = ref.watch(analyticsFilterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.filters, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l.all),
                  selected: filter.sex == null,
                  onSelected: (_) {
                    ref.read(analyticsFilterProvider.notifier).state =
                        filter.copyWith(clearSex: true);
                  },
                ),
                ChoiceChip(
                  label: Text(l.male),
                  selected: filter.sex == 'M',
                  onSelected: (_) {
                    ref.read(analyticsFilterProvider.notifier).state =
                        filter.copyWith(sex: 'M');
                  },
                ),
                ChoiceChip(
                  label: Text(l.female),
                  selected: filter.sex == 'F',
                  onSelected: (_) {
                    ref.read(analyticsFilterProvider.notifier).state =
                        filter.copyWith(sex: 'F');
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    filter.dateFrom != null
                        ? '${l.from}: ${filter.dateFrom!.day}/${filter.dateFrom!.month}/${filter.dateFrom!.year}'
                        : l.from,
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: filter.dateFrom ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          filter.copyWith(dateFrom: date);
                    }
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    filter.dateTo != null
                        ? '${l.to}: ${filter.dateTo!.day}/${filter.dateTo!.month}/${filter.dateTo!.year}'
                        : l.to,
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: filter.dateTo ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          filter.copyWith(dateTo: date);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final AnalyticsData data;
  const _SummaryRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Row(
      children: [
        _MiniStat(
            label: l.totalAssessments,
            value: '${data.totalAssessments}',
            color: AppColors.primary),
        const SizedBox(width: 8),
        _MiniStat(
            label: l.highRisk,
            value: '${data.highRiskCount}',
            color: AppColors.highRisk),
        const SizedBox(width: 8),
        _MiniStat(
            label: l.lowRisk,
            value: '${data.lowRiskCount}',
            color: AppColors.lowRisk),
        const SizedBox(width: 8),
        _MiniStat(
            label: l.average,
            value: data.averageScore.toStringAsFixed(1),
            color: AppColors.primary),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 2),
              Text(label,
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ScoreDistributionChart extends StatelessWidget {
  final AnalyticsData data;
  const _ScoreDistributionChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final dist = data.scoreDistribution;
    final maxVal =
        dist.values.fold<int>(0, (a, b) => a > b ? a : b).toDouble();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxVal > 0 ? maxVal + 1 : 5,
          barGroups: dist.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final val = entry.value.value.toDouble();
            final bucketStart = idx * 10;
            final isHighRisk = bucketStart >= CognitiveRiskCalculator.cutoff;
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: isHighRisk ? AppColors.highRisk : AppColors.lowRisk,
                  width: 28,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (v, _) =>
                    Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (v, _) {
                  final labels = dist.keys.toList();
                  final idx = v.toInt();
                  if (idx < 0 || idx >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(labels[idx],
                        style: const TextStyle(fontSize: 9)),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}

class _FactorFrequencyChart extends StatelessWidget {
  final AnalyticsData data;
  const _FactorFrequencyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final snakeToLabel = {
      'low_competence': l.lowCompetence,
      'hypertension': l.hypertension,
      'covid': l.covid,
      'low_education': l.lowEducation,
      'obesity': l.obesity,
      'diabetes': l.diabetes,
      'weight_loss': l.weightLoss,
      'inactivity': l.inactivity,
      'smoking': l.smoking,
    };

    final sorted = data.factorFrequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxVal = sorted.isNotEmpty
        ? sorted.first.value.toDouble()
        : 1.0;

    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          maxY: maxVal + 1,
          barGroups: sorted.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  color: Theme.of(context).colorScheme.primary,
                  width: 16,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (v, _) =>
                    Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= sorted.length) {
                    return const SizedBox.shrink();
                  }
                  final label =
                      snakeToLabel[sorted[idx].key] ?? sorted[idx].key;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(label,
                          style: const TextStyle(fontSize: 9)),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final AnalyticsData data;
  const _TrendChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final trend = data.monthlyTrend;
    final spots = trend
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.average))
        .toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: CognitiveRiskCalculator.maxScore.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color:
                    Theme.of(context).colorScheme.primary.withAlpha(20),
              ),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: CognitiveRiskCalculator.cutoff.toDouble(),
                color: Colors.orange.withAlpha(150),
                strokeWidth: 2,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => l.cutoff,
                  style: TextStyle(
                      color: Colors.orange.withAlpha(200),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 10,
                getTitlesWidget: (v, _) =>
                    Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= trend.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(trend[idx].label,
                        style: const TextStyle(fontSize: 9)),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (v) => FlLine(
              color: Theme.of(context).colorScheme.outline.withAlpha(30),
              strokeWidth: 1,
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final t = trend[s.x.toInt()];
                return LineTooltipItem(
                  '${l.average}: ${t.average.toStringAsFixed(1)}\n${t.count} ${l.assessments.toLowerCase()}',
                  const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CorrelationTable extends StatelessWidget {
  final AnalyticsData data;
  const _CorrelationTable({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final factorLabels = {
      'hypertension': l.hypertension,
      'lowCompetence': l.lowCompetence,
      'lowEducation': l.lowEducation,
      'covid': l.covid,
      'obesity': l.obesity,
      'diabetes': l.diabetes,
      'weightLoss': l.weightLoss,
      'inactivity': l.inactivity,
      'smoking': l.smoking,
    };

    final correlations = data.highRiskCorrelations;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.commonCombinations,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 12),
            ...correlations.asMap().entries.map((entry) {
              final idx = entry.key;
              final c = entry.value;
              final labelA = factorLabels[c.factorA] ?? c.factorA;
              final labelB = factorLabels[c.factorB] ?? c.factorB;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${idx + 1}.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text('$labelA + $labelB',
                          style: const TextStyle(fontSize: 13)),
                    ),
                    Text(
                      '${c.count}x',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${c.percentage.toStringAsFixed(0)}%',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: AppColors.highRisk,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
