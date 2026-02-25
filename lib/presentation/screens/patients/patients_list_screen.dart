import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/enums/risk_category.dart';
import '../../providers/patient_providers.dart';
import '../../providers/assessment_providers.dart';
import '../../widgets/risk_indicator.dart';
import 'patient_form_screen.dart';
import 'patient_detail_screen.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  late final AnimationController _staggerController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  Widget _staggeredCard(int index, Widget child) {
    if (index >= 10) return child;
    const maxAnimated = 10;
    final intervalStart = index / (maxAnimated + 2);
    final intervalEnd = (index + 2) / (maxAnimated + 2);
    final animation = CurvedAnimation(
      parent: _staggerController,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - animation.value)),
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final patientsAsync = _searchQuery.isEmpty
        ? ref.watch(patientsListProvider)
        : ref.watch(patientSearchProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.patients),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) {
                if (patients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? l.noPatients
                              : l.noResults,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }
                if (!_hasAnimated && _searchQuery.isEmpty) {
                  _hasAnimated = true;
                  _staggerController.forward(from: 0);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(patientsListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: patients.length,
                    itemBuilder: (context, index) => _staggeredCard(
                      index,
                      _PatientCard(patient: patients[index]),
                    ),
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${l.error}: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const PatientFormScreen()),
          );
          if (created == true) {
            ref.invalidate(patientsListProvider);
          }
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class _PatientCard extends ConsumerWidget {
  final Patient patient;

  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final latestAsync = ref.watch(latestAssessmentProvider(patient.id!));

    final borderColor = latestAsync.whenOrNull(
      data: (assessment) {
        if (assessment == null) return Colors.transparent;
        return assessment.riskCategory == RiskCategory.high
            ? AppColors.highRisk
            : AppColors.lowRisk;
      },
    ) ?? Colors.transparent;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: borderColor),
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    (patient.name ?? patient.patientCode)
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  patient.name ?? patient.patientCode,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${l.patientCode}: ${patient.patientCode} | ${l.age}: ${patient.age}'),
                    latestAsync.when(
                      data: (assessment) {
                        if (assessment == null) {
                          return Text(l.noAssessments,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic));
                        }
                        return Row(
                          children: [
                            Text('${l.score}: ${assessment.totalScore}  '),
                            RiskIndicator(
                              category: assessment.riskCategory,
                              size: 10,
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                isThreeLine: true,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PatientDetailScreen(patient: patient),
                    ),
                  );
                  ref.invalidate(patientsListProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
