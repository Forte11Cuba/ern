import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../../domain/enums/risk_category.dart';
import '../../../domain/entities/reevaluation_reminder.dart';
import '../../../domain/services/recommendation_service.dart';
import '../../../services/notifications/notification_service.dart';
import '../../providers/assessment_providers.dart';
import '../../providers/database_providers.dart';
import '../result/result_screen.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  final Patient patient;
  final CognitiveAssessment? existing;

  const AssessmentScreen({
    super.key,
    required this.patient,
    this.existing,
  });

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  final _notesController = TextEditingController();
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(assessmentFormProvider.notifier);
      if (_isEditing) {
        notifier.loadFromAssessment(widget.existing!);
        _notesController.text = widget.existing!.clinicalNotes ?? '';
      } else {
        notifier.reset();
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final input = ref.watch(assessmentFormProvider);
    final notifier = ref.read(assessmentFormProvider.notifier);
    final score = notifier.currentScore;
    final category = notifier.currentCategory;
    final isHigh = category == RiskCategory.high;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l.editAssessment : l.newAssessment),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: (isHigh ? AppColors.highRisk : AppColors.lowRisk)
                .withAlpha(25),
            child: Column(
              children: [
                Text(
                  widget.patient.name ?? widget.patient.patientCode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '$score',
                    key: ValueKey(score),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isHigh ? AppColors.highRisk : AppColors.lowRisk,
                        ),
                  ),
                ),
                Text(
                  '/ ${CognitiveRiskCalculator.maxScore}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Chip(
                    key: ValueKey(category),
                    label: Text(
                      isHigh ? l.highRisk : l.lowRisk,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor:
                        isHigh ? AppColors.highRisk : AppColors.lowRisk,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _factorTile(
                  l.lowCompetence,
                  '${CognitiveRiskCalculator.factorWeights['lowCompetence']} ${l.pts}',
                  Icons.psychology_outlined,
                  input.lowCompetence,
                  notifier.toggleLowCompetence,
                  l.defLowCompetence,
                ),
                _factorTile(
                  l.hypertension,
                  '${CognitiveRiskCalculator.factorWeights['hypertension']} ${l.pts}',
                  Icons.favorite_outline,
                  input.hypertension,
                  notifier.toggleHypertension,
                  l.defHypertension,
                ),
                _factorTile(
                  l.covid,
                  '${CognitiveRiskCalculator.factorWeights['covid']} ${l.pts}',
                  Icons.coronavirus_outlined,
                  input.covid,
                  notifier.toggleCovid,
                  l.defCovid,
                ),
                _factorTile(
                  l.lowEducation,
                  '${CognitiveRiskCalculator.factorWeights['lowEducation']} ${l.pts}',
                  Icons.school_outlined,
                  input.lowEducation,
                  notifier.toggleLowEducation,
                  l.defLowEducation,
                ),
                _factorTile(
                  l.obesity,
                  '${CognitiveRiskCalculator.factorWeights['obesity']} ${l.pts}',
                  Icons.monitor_weight_outlined,
                  input.obesity,
                  notifier.toggleObesity,
                  l.defObesity,
                ),
                _factorTile(
                  l.diabetes,
                  '${CognitiveRiskCalculator.factorWeights['diabetes']} ${l.pts}',
                  Icons.bloodtype_outlined,
                  input.diabetes,
                  notifier.toggleDiabetes,
                  l.defDiabetes,
                ),
                _factorTile(
                  l.weightLoss,
                  '${CognitiveRiskCalculator.factorWeights['weightLoss']} ${l.pts}',
                  Icons.trending_down,
                  input.weightLoss,
                  notifier.toggleWeightLoss,
                  l.defWeightLoss,
                ),
                _factorTile(
                  l.inactivity,
                  '${CognitiveRiskCalculator.factorWeights['inactivity']} ${l.pts}',
                  Icons.weekend_outlined,
                  input.inactivity,
                  notifier.toggleInactivity,
                  l.defInactivity,
                ),
                _factorTile(
                  l.smoking,
                  '${CognitiveRiskCalculator.factorWeights['smoking']} ${l.pts}',
                  Icons.smoking_rooms_outlined,
                  input.smoking,
                  notifier.toggleSmoking,
                  l.defSmoking,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l.clinicalNotes,
                    prefixIcon: const Icon(Icons.note_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEditing
                        ? l.saveChanges
                        : l.saveAssessment),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _factorTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    void Function(bool) onChanged,
    String definitionText,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 20,
                icon: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: () => _showDefinition(title, definitionText),
              ),
            ),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onChanged(v);
          },
          activeColor: AppColors.highRisk,
        ),
      ),
    );
  }

  void _showDefinition(String title, String definition) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_information_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        l.clinicalDefinition,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(definition, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _saving = true);

    try {
      final notifier = ref.read(assessmentFormProvider.notifier);
      final input = ref.read(assessmentFormProvider);
      final score = notifier.currentScore;
      final category = notifier.currentCategory;
      final repo = ref.read(assessmentRepositoryProvider);
      final now = DateTime.now();
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      CognitiveAssessment saved;

      if (_isEditing) {
        saved = widget.existing!.copyWith(
          hypertension: input.hypertension,
          lowCompetence: input.lowCompetence,
          lowEducation: input.lowEducation,
          covid: input.covid,
          obesity: input.obesity,
          diabetes: input.diabetes,
          weightLoss: input.weightLoss,
          inactivity: input.inactivity,
          smoking: input.smoking,
          totalScore: score,
          riskCategory: category,
          clinicalNotes: notes,
          updatedAt: now,
        );
        await repo.update(saved);
      } else {
        saved = CognitiveAssessment(
          patientId: widget.patient.id!,
          hypertension: input.hypertension,
          lowCompetence: input.lowCompetence,
          lowEducation: input.lowEducation,
          covid: input.covid,
          obesity: input.obesity,
          diabetes: input.diabetes,
          weightLoss: input.weightLoss,
          inactivity: input.inactivity,
          smoking: input.smoking,
          totalScore: score,
          riskCategory: category,
          clinicalNotes: notes,
          createdAt: now,
        );
        final id = await repo.create(saved);
        saved = saved.copyWith(id: id);
      }

      // Create reevaluation reminder
      final recService = RecommendationService();
      final intervalMonths = recService.reevaluationIntervalMonths(category);
      final reminderRepo = ref.read(reminderRepositoryProvider);

      await reminderRepo.cancelPendingForPatient(widget.patient.id!);

      final reminder = ReevaluationReminder(
        patientId: widget.patient.id!,
        assessmentId: saved.id!,
        scheduledDate: now.copyWith(month: now.month + intervalMonths),
        intervalMonths: intervalMonths,
        createdAt: now,
      );
      final reminderId = await reminderRepo.create(reminder);

      try {
        await NotificationService().scheduleReminder(
          id: reminderId,
          title: l.reevaluationPending,
          body: l.reevaluationScheduled(
              widget.patient.name ?? widget.patient.patientCode),
          scheduledDate: reminder.scheduledDate,
        );
      } catch (_) {}

      await HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              patient: widget.patient,
              assessment: saved,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
