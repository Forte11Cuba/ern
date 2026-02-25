import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/entities/assessment_version.dart';
import '../../../domain/enums/risk_category.dart';
import '../../providers/database_providers.dart';
import '../../widgets/risk_indicator.dart';

class VersionHistoryScreen extends ConsumerStatefulWidget {
  final CognitiveAssessment assessment;

  const VersionHistoryScreen({super.key, required this.assessment});

  @override
  ConsumerState<VersionHistoryScreen> createState() =>
      _VersionHistoryScreenState();
}

class _VersionHistoryScreenState extends ConsumerState<VersionHistoryScreen> {
  List<AssessmentVersion>? _versions;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    final repo = ref.read(assessmentRepositoryProvider);
    final versions = await repo.getVersionHistory(widget.assessment.id!);
    setState(() {
      _versions = versions;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.versionHistory),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _versions == null || _versions!.isEmpty
              ? Center(child: Text(l.noVersions))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Current version card
                    _buildCurrentVersionCard(context, l),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        l.previousVersions,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    // Previous versions
                    ..._versions!.asMap().entries.map((entry) {
                      final v = entry.value;
                      final nextVersion = entry.key < _versions!.length - 1
                          ? _versions![entry.key + 1]
                          : null;
                      return _buildVersionCard(context, l, v, nextVersion);
                    }),
                  ],
                ),
    );
  }

  Widget _buildCurrentVersionCard(BuildContext context, AppLocalizations l) {
    final a = widget.assessment;
    final color = a.riskCategory == RiskCategory.high
        ? AppColors.highRisk
        : AppColors.lowRisk;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text('v${a.version} (${l.currentVersion})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                const Spacer(),
                Text(
                  '${l.score}: ${a.totalScore}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RiskIndicator(category: a.riskCategory, size: 11),
            if (a.updatedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l.editedDate('${a.updatedAt!.day}/${a.updatedAt!.month}/${a.updatedAt!.year} ${a.updatedAt!.hour}:${a.updatedAt!.minute.toString().padLeft(2, '0')}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard(
    BuildContext context,
    AppLocalizations l,
    AssessmentVersion v,
    AssessmentVersion? previousVersion,
  ) {
    final color = v.riskCategory == RiskCategory.high
        ? AppColors.highRisk
        : AppColors.lowRisk;
    final labels = AppConstants.localizedFactorLabels(l);

    // Compute diff with current assessment
    final currentFactors = widget.assessment.factorsMap;
    final versionFactors = _versionFactorsMap(v);
    final changes = <String>[];
    for (final key in currentFactors.keys) {
      final label = labels[key] ?? key;
      final cur = currentFactors[key]!;
      final old = versionFactors[key]!;
      if (cur != old) {
        changes.add(cur
            ? l.factorChangeToActive(label)
            : l.factorChangeToInactive(label));
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          radius: 18,
          child: Text(
            '${v.totalScore}',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        title: Row(
          children: [
            Text(l.versionLabel(v.versionNumber)),
            const SizedBox(width: 8),
            RiskIndicator(category: v.riskCategory, size: 9),
          ],
        ),
        subtitle: Text(
          '${v.changedAt.day}/${v.changedAt.month}/${v.changedAt.year} ${v.changedAt.hour}:${v.changedAt.minute.toString().padLeft(2, '0')}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Changes diff (comparing this version to current)
                if (changes.isNotEmpty) ...[
                  Text(
                    l.changesVsCurrent,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  ...changes.map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.change_circle_outlined,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(c,
                                    style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                ],
                // All factors in this version
                Text(
                  l.factorsInVersion,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                ...versionFactors.entries.map((e) {
                  final label = labels[e.key] ?? e.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          e.value
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: e.value
                              ? AppColors.highRisk
                              : Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 8),
                        Text(label, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }),
                if (v.clinicalNotes != null &&
                    v.clinicalNotes!.isNotEmpty) ...[
                  const Divider(height: 20),
                  Text(l.notesContent(v.clinicalNotes!),
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, bool> _versionFactorsMap(AssessmentVersion v) {
    return {
      'lowCompetence': v.lowCompetence,
      'hypertension': v.hypertension,
      'covid': v.covid,
      'lowEducation': v.lowEducation,
      'obesity': v.obesity,
      'diabetes': v.diabetes,
      'weightLoss': v.weightLoss,
      'inactivity': v.inactivity,
      'smoking': v.smoking,
    };
  }
}
