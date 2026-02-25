import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../widgets/risk_indicator.dart';

class EvolutionChartScreen extends StatelessWidget {
  final Patient patient;
  final List<CognitiveAssessment> assessments; // chronological order (oldest first)

  const EvolutionChartScreen({
    super.key,
    required this.patient,
    required this.assessments,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.evolutionChart),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        children: [
          // Patient name
          Text(
            patient.name ?? patient.patientCode,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l.evaluationsCount(assessments.length),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Chart
          Expanded(
            child: _buildChart(context, l),
          ),
          const SizedBox(height: 16),
          // Legend
          _buildLegend(context, l),
          const SizedBox(height: 16),
          // Data table
          Expanded(child: SingleChildScrollView(child: _buildDataTable(context, l))),
        ],
      ),),
    );
  }

  Widget _buildChart(BuildContext context, AppLocalizations l) {
    final spots = <FlSpot>[];
    for (int i = 0; i < assessments.length; i++) {
      spots.add(FlSpot(i.toDouble(), assessments[i].totalScore.toDouble()));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: CognitiveRiskCalculator.maxScore.toDouble(),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            if (value == CognitiveRiskCalculator.cutoff.toDouble()) {
              return FlLine(
                color: Colors.orange.withAlpha(150),
                strokeWidth: 2,
                dashArray: [8, 4],
              );
            }
            return FlLine(
              color: Theme.of(context).colorScheme.outline.withAlpha(30),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= assessments.length) {
                  return const SizedBox.shrink();
                }
                final date = assessments[idx].createdAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(60)),
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(60)),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: CognitiveRiskCalculator.cutoff.toDouble(),
              color: Colors.orange.withAlpha(150),
              strokeWidth: 2,
              dashArray: [8, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                labelResolver: (_) => '${l.cutoff}: ${CognitiveRiskCalculator.cutoff}',
                style: TextStyle(
                  color: Colors.orange.withAlpha(200),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final score = spot.y.toInt();
                final isHigh = score >= CognitiveRiskCalculator.cutoff;
                return FlDotCirclePainter(
                  radius: 5,
                  color: isHigh ? AppColors.highRisk : AppColors.lowRisk,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withAlpha(20),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                final a = assessments[idx];
                return LineTooltipItem(
                  '${l.score}: ${a.totalScore}\n${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, AppLocalizations l) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(context, AppColors.lowRisk, l.lowRisk),
        const SizedBox(width: 24),
        _legendItem(context, AppColors.highRisk, l.highRisk),
        const SizedBox(width: 24),
        _legendItem(context, Colors.orange, '${l.cutoff} (${CognitiveRiskCalculator.cutoff})'),
      ],
    );
  }

  Widget _legendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                Text(l.date,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(l.score,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(l.category,
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            ...assessments.reversed.map((a) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${a.totalScore}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: a.totalScore >= CognitiveRiskCalculator.cutoff
                            ? AppColors.highRisk
                            : AppColors.lowRisk,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RiskIndicator(
                          category: a.riskCategory, size: 9),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
