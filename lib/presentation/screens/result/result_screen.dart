import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/enums/risk_category.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../../services/pdf/pdf_report_generator.dart';

class ResultScreen extends StatefulWidget {
  final Patient patient;
  final CognitiveAssessment assessment;

  const ResultScreen({
    super.key,
    required this.patient,
    required this.assessment,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final a = widget.assessment;
    final isHigh = a.riskCategory == RiskCategory.high;
    final color = isHigh ? AppColors.highRisk : AppColors.lowRisk;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.result),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(25),
                  border: Border.all(color: color, width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${a.totalScore}',
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                    ),
                    Text(
                      '/ ${CognitiveRiskCalculator.maxScore}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Chip(
              label: Text(
                (isHigh ? l.highRisk : l.lowRisk).toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              widget.patient.name ?? widget.patient.patientCode,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 24),
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
                  ..._buildFactorRows(context, l, a),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                        isHigh ? Icons.warning_amber : Icons.check_circle_outline,
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
                  Text(isHigh
                      ? l.highRiskRecommendation
                      : l.lowRiskRecommendation),
                ],
              ),
            ),
          ),
          _buildSpecificRecommendations(context, l, a),
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
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    final pdfGen = PdfReportGenerator();
                    final bytes = await pdfGen.generateIndividualReport(
                      patient: widget.patient,
                      assessment: widget.assessment,
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
                child: FilledButton.icon(
                  onPressed: () async {
                    final pdfGen = PdfReportGenerator();
                    final bytes = await pdfGen.generateIndividualReport(
                      patient: widget.patient,
                      assessment: widget.assessment,
                      l: l,
                    );
                    final dir = await getApplicationDocumentsDirectory();
                    final file = File(
                        '${dir.path}/evaluacion_${widget.patient.patientCode}_${DateTime.now().millisecondsSinceEpoch}.pdf');
                    await file.writeAsBytes(bytes);
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      subject: '${l.result} ${widget.patient.patientCode}',
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: Text(l.share),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSpecificRecommendations(
      BuildContext context, AppLocalizations l, CognitiveAssessment a) {
    final factorRecs = <String, MapEntry<String, String>>{
      'lowCompetence': MapEntry(l.lowCompetence, l.recLowCompetence),
      'hypertension': MapEntry(l.hypertension, l.recHypertension),
      'covid': MapEntry(l.covid, l.recCovid),
      'lowEducation': MapEntry(l.lowEducation, l.recLowEducation),
      'obesity': MapEntry(l.obesity, l.recObesity),
      'diabetes': MapEntry(l.diabetes, l.recDiabetes),
      'weightLoss': MapEntry(l.weightLoss, l.recWeightLoss),
      'inactivity': MapEntry(l.inactivity, l.recInactivity),
      'smoking': MapEntry(l.smoking, l.recSmoking),
    };

    final activeRecs = a.factorsMap.entries
        .where((e) => e.value && factorRecs.containsKey(e.key))
        .map((e) => factorRecs[e.key]!)
        .toList();

    if (activeRecs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l.specificRecommendations,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...activeRecs.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\u2022 ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${rec.key}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: rec.value),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFactorRows(
      BuildContext context, AppLocalizations l, CognitiveAssessment a) {
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

    return a.factorsMap.entries.map((e) {
      final label = factorLabels[e.key] ?? e.key;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
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
              e.value ? l.yes : l.no,
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
    }).toList();
  }
}
