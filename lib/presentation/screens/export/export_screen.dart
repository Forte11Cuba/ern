import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/entities/patient.dart';
import '../../../services/export/csv_export_service.dart';
import '../../../services/pdf/pdf_report_generator.dart';
import '../../providers/database_providers.dart';
import 'package:printing/printing.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  String? _riskFilter;
  String? _sexFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.exportData)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.exportFilters,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(l.riskCategory,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l.all),
                        selected: _riskFilter == null,
                        onSelected: (_) =>
                            setState(() => _riskFilter = null),
                      ),
                      ChoiceChip(
                        label: Text(l.highRisk),
                        selected: _riskFilter == 'high',
                        selectedColor: AppColors.highRisk.withAlpha(50),
                        onSelected: (_) =>
                            setState(() => _riskFilter = 'high'),
                      ),
                      ChoiceChip(
                        label: Text(l.lowRisk),
                        selected: _riskFilter == 'low',
                        selectedColor: AppColors.lowRisk.withAlpha(50),
                        onSelected: (_) =>
                            setState(() => _riskFilter = 'low'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l.sex,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l.all),
                        selected: _sexFilter == null,
                        onSelected: (_) =>
                            setState(() => _sexFilter = null),
                      ),
                      ChoiceChip(
                        label: Text(l.male),
                        selected: _sexFilter == 'M',
                        onSelected: (_) =>
                            setState(() => _sexFilter = 'M'),
                      ),
                      ChoiceChip(
                        label: Text(l.female),
                        selected: _sexFilter == 'F',
                        onSelected: (_) =>
                            setState(() => _sexFilter = 'F'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l.dateRange,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _dateFrom != null
                                ? '${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}'
                                : l.from,
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _dateFrom ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => _dateFrom = date);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _dateTo != null
                                ? '${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}'
                                : l.to,
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _dateTo ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => _dateTo = date);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_dateFrom != null || _dateTo != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() {
                          _dateFrom = null;
                          _dateTo = null;
                        }),
                        child: Text(l.clearDates),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.exportFormat,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _ExportButton(
            icon: Icons.table_chart,
            title: l.exportCsv,
            subtitle: l.csvSubtitle,
            loading: _exporting,
            onPressed: _exportCsv,
          ),
          const SizedBox(height: 8),
          _ExportButton(
            icon: Icons.picture_as_pdf,
            title: l.statisticsPdf,
            subtitle: l.statisticsPdfSubtitle,
            loading: _exporting,
            onPressed: _exportAggregatePdf,
          ),
        ],
      ),
    );
  }

  Future<_FilteredData> _getFilteredData() async {
    final assessmentRepo = ref.read(assessmentRepositoryProvider);
    final patientRepo = ref.read(patientRepositoryProvider);

    final assessments = await assessmentRepo.getByFilters(
      riskCategory: _riskFilter,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );

    var patients = await patientRepo.getAll();

    if (_sexFilter != null) {
      patients = patients.where((p) => p.sex == _sexFilter).toList();
      final patientIds = patients.map((p) => p.id).toSet();
      return _FilteredData(
        patients: patients,
        assessments:
            assessments.where((a) => patientIds.contains(a.patientId)).toList(),
      );
    }

    return _FilteredData(patients: patients, assessments: assessments);
  }

  Future<void> _exportCsv() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _exporting = true);
    try {
      final data = await _getFilteredData();
      final csvService = CsvExportService();
      final csv = await csvService.generateCsv(
        patients: data.patients,
        assessments: data.assessments,
        l: l,
      );
      await csvService.shareCsv(csv, l: l);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _exportAggregatePdf() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _exporting = true);
    try {
      final data = await _getFilteredData();
      final assessmentRepo = ref.read(assessmentRepositoryProvider);
      final frequencies = await assessmentRepo.factorFrequencies();

      final pdfGen = PdfReportGenerator();
      final pdfBytes = await pdfGen.generateAggregateReport(
        patients: data.patients,
        assessments: data.assessments,
        factorFrequencies: frequencies,
        l: l,
      );

      if (mounted) {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename:
              'estadisticas_ern_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _FilteredData {
  final List<Patient> patients;
  final List<CognitiveAssessment> assessments;
  const _FilteredData({required this.patients, required this.assessments});
}

class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool loading;
  final VoidCallback onPressed;

  const _ExportButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download),
        onTap: loading ? null : onPressed,
      ),
    );
  }
}
