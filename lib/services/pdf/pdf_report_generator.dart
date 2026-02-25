import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/entities/patient.dart';
import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/calculators/cognitive_risk_calculator.dart';
import '../../domain/enums/risk_category.dart';

class PdfReportGenerator {

  Future<Uint8List> generateIndividualReport({
    required Patient patient,
    required CognitiveAssessment assessment,
    required AppLocalizations l,
  }) async {
    final pdf = pw.Document();
    final recommendation = assessment.riskCategory == RiskCategory.high
        ? l.highRiskRecommendation
        : l.lowRiskRecommendation;
    final isHigh = assessment.riskCategory == RiskCategory.high;
    final riskColor = isHigh
        ? const PdfColor.fromInt(0xFFF44336)
        : const PdfColor.fromInt(0xFF4CAF50);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  l.appName,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: const PdfColor.fromInt(0xFF1565C0),
                  ),
                ),
                pw.Text(
                  l.datePrefix(_formatDate(DateTime.now())),
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xFF1565C0)),
            pw.SizedBox(height: 16),

            // Patient info
            pw.Text(
              l.patientData,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildInfoTable(patient, l),
            pw.SizedBox(height: 8),
            pw.Text(
              l.assessmentDateLabel(_formatDate(assessment.createdAt)) +
              (assessment.version > 1 ? '  ${l.versionInParens(assessment.version)}' : ''),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 20),

            // Score
            pw.Center(
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: riskColor, width: 2),
                  borderRadius: pw.BorderRadius.circular(8),
                  color: riskColor.shade(0.95),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      l.scoreTotalDisplay(assessment.totalScore, CognitiveRiskCalculator.maxScore),
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      (assessment.riskCategory == RiskCategory.high
                              ? l.highRisk
                              : l.lowRisk)
                          .toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Factors table
            pw.Text(
              l.riskFactors,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildFactorsTable(assessment, l),
            pw.SizedBox(height: 20),

            // Recommendation
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: riskColor),
                borderRadius: pw.BorderRadius.circular(6),
                color: riskColor.shade(0.97),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    l.clinicalRecommendation,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(recommendation, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),

            // Clinical notes
            if (assessment.clinicalNotes != null &&
                assessment.clinicalNotes!.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              pw.Text(
                l.clinicalNotes,
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(assessment.clinicalNotes!,
                  style: const pw.TextStyle(fontSize: 10)),
            ],

            pw.Spacer(),

            // Footer
            pw.Divider(color: PdfColors.grey400),
            pw.Text(
              l.pdfFooter,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> generateAggregateReport({
    required List<Patient> patients,
    required List<CognitiveAssessment> assessments,
    required Map<String, int> factorFrequencies,
    required AppLocalizations l,
  }) async {
    final pdf = pw.Document();
    final totalPatients = patients.length;
    final totalAssessments = assessments.length;
    final highRisk =
        assessments.where((a) => a.riskCategory == RiskCategory.high).length;
    final lowRisk = totalAssessments - highRisk;
    final avgScore = totalAssessments > 0
        ? assessments.map((a) => a.totalScore).reduce((a, b) => a + b) /
            totalAssessments
        : 0.0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Text(
              '${l.appName} — ${l.aggregateStatistics}',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF1565C0),
              ),
            ),
            pw.Text(
              l.generatedDate(_formatDate(DateTime.now())),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xFF1565C0)),
            pw.SizedBox(height: 20),

            // Summary stats
            pw.Text(
              l.generalSummary,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                _tableRow(l.totalPatientsLabel, '$totalPatients', bold: true),
                _tableRow(l.totalAssessmentsLabel, '$totalAssessments'),
                _tableRow(l.highRisk, '$highRisk',
                    color: const PdfColor.fromInt(0xFFF44336)),
                _tableRow(l.lowRisk, '$lowRisk',
                    color: const PdfColor.fromInt(0xFF4CAF50)),
                _tableRow(l.averageScore, avgScore.toStringAsFixed(1)),
              ],
            ),
            pw.SizedBox(height: 24),

            // Factor frequencies
            pw.Text(
              l.factorFrequency,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cell(l.factor, bold: true),
                    _cell(l.amount, bold: true),
                    _cell('%', bold: true),
                  ],
                ),
                ...factorFrequencies.entries.map((e) {
                  final label = _localizedSnakeLabel(e.key, l);
                  final pct = totalAssessments > 0
                      ? (e.value / totalAssessments * 100)
                          .toStringAsFixed(1)
                      : '0.0';
                  return pw.TableRow(
                    children: [
                      _cell(label),
                      _cell('${e.value}'),
                      _cell('$pct%'),
                    ],
                  );
                }),
              ],
            ),

            pw.Spacer(),
            pw.Divider(color: PdfColors.grey400),
            pw.Text(
              l.pdfFooter,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildInfoTable(Patient patient, AppLocalizations l) {
    final rows = <pw.TableRow>[
      _tableRow(l.codeLabel, patient.patientCode),
      if (patient.name != null) _tableRow(l.nameLabel, patient.name!),
      _tableRow(l.age, '${patient.age}'),
      if (patient.sex != null)
        _tableRow(l.sex, patient.sex == 'M' ? l.male : l.female),
      if (patient.medicalRecord != null)
        _tableRow(l.medicalRecord, patient.medicalRecord!),
    ];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: rows,
    );
  }

  pw.Widget _buildFactorsTable(CognitiveAssessment assessment, AppLocalizations l) {
    final factors = assessment.factorsMap;
    final labels = AppConstants.localizedFactorLabels(l);
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cell(l.factor, bold: true),
            _cell(l.present, bold: true),
            _cell(l.points, bold: true),
          ],
        ),
        ...factors.entries.map((e) {
          final label = labels[e.key] ?? e.key;
          final weight = CognitiveRiskCalculator.factorWeights[e.key] ?? 0;
          return pw.TableRow(
            children: [
              _cell(label),
              _cell(e.value ? l.yes : l.no),
              _cell(e.value ? '+$weight' : '—'),
            ],
          );
        }),
      ],
    );
  }

  pw.TableRow _tableRow(String label, String value,
      {bool bold = false, PdfColor? color}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : null,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : null,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _localizedSnakeLabel(String snake, AppLocalizations l) {
    switch (snake) {
      case 'hypertension': return l.hypertension;
      case 'low_competence': return l.lowCompetence;
      case 'low_education': return l.lowEducation;
      case 'covid': return l.covid;
      case 'obesity': return l.obesity;
      case 'diabetes': return l.diabetes;
      case 'weight_loss': return l.weightLoss;
      case 'inactivity': return l.inactivity;
      case 'smoking': return l.smoking;
      default: return snake;
    }
  }
}
