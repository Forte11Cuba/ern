import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/entities/patient.dart';
import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/enums/risk_category.dart';

class CsvExportService {
  Future<String> generateCsv({
    required List<Patient> patients,
    required List<CognitiveAssessment> assessments,
    required AppLocalizations l,
  }) async {
    final patientMap = {for (final p in patients) p.id: p};
    final factorLabels = AppConstants.localizedFactorLabels(l);

    final headers = [
      l.codeLabel,
      l.nameLabel,
      l.age,
      l.sex,
      l.assessmentDateHeader,
      ...factorLabels.values,
      l.totalScoreHeader,
      l.category,
      l.clinicalNotes,
      l.version,
    ];

    final rows = <List<dynamic>>[headers];

    for (final a in assessments) {
      final patient = patientMap[a.patientId];
      rows.add([
        patient?.patientCode ?? '',
        patient?.name ?? '',
        patient?.age ?? '',
        patient?.sex == 'M'
            ? l.male
            : patient?.sex == 'F'
                ? l.female
                : '',
        _formatDate(a.createdAt),
        a.lowCompetence ? l.yes : l.no,
        a.hypertension ? l.yes : l.no,
        a.covid ? l.yes : l.no,
        a.lowEducation ? l.yes : l.no,
        a.obesity ? l.yes : l.no,
        a.diabetes ? l.yes : l.no,
        a.weightLoss ? l.yes : l.no,
        a.inactivity ? l.yes : l.no,
        a.smoking ? l.yes : l.no,
        a.totalScore,
        a.riskCategory == RiskCategory.high ? l.highRisk : l.lowRisk,
        a.clinicalNotes ?? '',
        a.version,
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<File> saveCsvToFile(String csvContent) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/evaluaciones_$timestamp.csv');
    return file.writeAsString(csvContent);
  }

  Future<void> shareCsv(String csvContent, {required AppLocalizations l}) async {
    final file = await saveCsvToFile(csvContent);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: l.csvExportSubject(l.appName),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
