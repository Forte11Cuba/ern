import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/entities/patient.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/assessment_providers.dart';
import '../../providers/patient_providers.dart';
import '../../widgets/risk_indicator.dart';
import 'patient_form_screen.dart';
import '../assessment/assessment_screen.dart';
import '../history/history_screen.dart';
import '../history/assessment_detail_screen.dart';

class PatientDetailScreen extends ConsumerWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final assessmentsAsync =
        ref.watch(assessmentsByPatientProvider(patient.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name ?? patient.patientCode),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final edited = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => PatientFormScreen(patient: patient),
                ),
              );
              if (edited == true) {
                ref.invalidate(patientByIdProvider(patient.id!));
                ref.invalidate(patientsListProvider);
              }
            },
          ),
        ],
      ),
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
                    l.patientData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(context, l.patientCode, patient.patientCode),
                  if (patient.name != null)
                    _infoRow(context, l.patientName, patient.name!),
                  _infoRow(context, l.age, '${patient.age}'),
                  if (patient.sex != null)
                    _infoRow(context, l.sex,
                        patient.sex == 'M' ? l.male : l.female),
                  if (patient.birthDate != null)
                    _infoRow(context, l.birthDate,
                        '${patient.birthDate!.day}/${patient.birthDate!.month}/${patient.birthDate!.year}'),
                  if (patient.medicalRecord != null)
                    _infoRow(context, l.medicalRecord, patient.medicalRecord!),
                  if (patient.notes != null && patient.notes!.isNotEmpty)
                    _infoRow(context, l.notes, patient.notes!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.assessments,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.filter_list, size: 18),
                label: Text(l.history),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(patient: patient),
                    ),
                  );
                  ref.invalidate(assessmentsByPatientProvider(patient.id!));
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          assessmentsAsync.when(
            data: (assessments) {
              if (assessments.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(l.noAssessments),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: assessments.map((a) {
                  final color = a.riskCategory.name == 'high'
                      ? AppColors.highRisk
                      : AppColors.lowRisk;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withAlpha(30),
                        child: Text(
                          '${a.totalScore}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text('${l.score}: ${a.totalScore}/59  '),
                          RiskIndicator(
                            category: a.riskCategory,
                            size: 10,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}'
                        '${a.version > 1 ? "  (v${a.version})" : ""}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AssessmentDetailScreen(
                              patient: patient,
                              assessment: a,
                            ),
                          ),
                        );
                        ref.invalidate(
                            assessmentsByPatientProvider(patient.id!));
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('${l.error}: $e'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AssessmentScreen(patient: patient),
            ),
          );
          ref.invalidate(assessmentsByPatientProvider(patient.id!));
        },
        icon: const Icon(Icons.add_chart),
        label: Text(l.newAssessment),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
