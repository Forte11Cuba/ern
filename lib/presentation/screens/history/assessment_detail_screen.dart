import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/enums/risk_category.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../../services/pdf/pdf_report_generator.dart';
import '../../widgets/risk_indicator.dart';
import '../assessment/assessment_screen.dart';
import 'version_history_screen.dart';

class AssessmentDetailScreen extends ConsumerStatefulWidget {
  final Patient patient;
  final CognitiveAssessment assessment;

  const AssessmentDetailScreen({
    super.key,
    required this.patient,
    required this.assessment,
  });

  @override
  ConsumerState<AssessmentDetailScreen> createState() =>
      _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState
    extends ConsumerState<AssessmentDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final a = widget.assessment;
    final isHigh = a.riskCategory == RiskCategory.high;
    final color = isHigh ? AppColors.highRisk : AppColors.lowRisk;
    final recommendation = isHigh ? l.highRiskRecommendation : l.lowRiskRecommendation;
    final labels = AppConstants.localizedFactorLabels(l);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.assessmentDetail),
        actions: [
          if (a.version > 1)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l.versionHistory,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VersionHistoryScreen(
                      assessment: a,
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l.editAssessment,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AssessmentScreen(
                    patient: widget.patient,
                    existing: a,
                  ),
                ),
              );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score card
          Card(
            color: color.withAlpha(15),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withAlpha(25),
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${a.totalScore}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                        ),
                        Text(
                          '/ ${CognitiveRiskCalculator.maxScore}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: color,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  RiskIndicator(category: a.riskCategory, size: 14),
                  const SizedBox(height: 8),
                  Text(
                    l.assessmentFromDate('${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  if (a.version > 1)
                    Text(
                      l.versionEditedDate(a.version, '${a.updatedAt?.day}/${a.updatedAt?.month}/${a.updatedAt?.year}'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Factors table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.riskFactors,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...a.factorsMap.entries.map((e) {
                    final label = labels[e.key] ?? e.key;
                    final weight = CognitiveRiskCalculator.factorWeights[e.key] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            e.value
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 20,
                            color: e.value
                                ? AppColors.highRisk
                                : Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(label)),
                          Text(
                            e.value ? '+$weight ${l.pts}' : '—',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: e.value
                                  ? AppColors.highRisk
                                  : Theme.of(context).colorScheme.outline,
                            ),
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
          // Recommendation
          Card(
            color: color.withAlpha(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isHigh
                            ? Icons.warning_amber
                            : Icons.check_circle_outline,
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l.recommendation,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(recommendation),
                ],
              ),
            ),
          ),
          // Clinical notes
          if (a.clinicalNotes != null && a.clinicalNotes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.clinicalNotes,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(a.clinicalNotes!),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Action row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final pdfGen = PdfReportGenerator();
                    final bytes = await pdfGen.generateIndividualReport(
                      patient: widget.patient,
                      assessment: a,
                      l: l,
                    );
                    if (context.mounted) {
                      await Printing.sharePdf(
                        bytes: bytes,
                        filename:
                            'evaluacion_${widget.patient.patientCode}_${DateTime.now().millisecondsSinceEpoch}.pdf',
                      );
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: Text(l.pdf),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AssessmentScreen(
                          patient: widget.patient,
                          existing: a,
                        ),
                      ),
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(l.edit),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
