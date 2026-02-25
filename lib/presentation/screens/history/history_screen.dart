import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/entities/cognitive_assessment.dart';
import '../../../domain/enums/risk_category.dart';
import '../../providers/database_providers.dart';
import '../../widgets/risk_indicator.dart';
import 'assessment_detail_screen.dart';
import 'comparison_screen.dart';
import 'evolution_chart_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final Patient patient;

  const HistoryScreen({super.key, required this.patient});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // Filters
  String? _riskFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final Set<String> _activeFactorFilters = {};
  bool _filtersExpanded = false;

  // Comparison mode
  bool _compareMode = false;
  final Set<int> _selectedForCompare = {};

  List<CognitiveAssessment>? _assessments;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  Future<void> _loadAssessments() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(assessmentRepositoryProvider);
      final results = await repo.getByFilters(
        patientId: widget.patient.id!,
        riskCategory: _riskFilter,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        activeFactors:
            _activeFactorFilters.isEmpty ? null : _activeFactorFilters.toList(),
      );
      setState(() {
        _assessments = results;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _clearFilters() {
    setState(() {
      _riskFilter = null;
      _dateFrom = null;
      _dateTo = null;
      _activeFactorFilters.clear();
    });
    _loadAssessments();
  }

  bool get _hasActiveFilters =>
      _riskFilter != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _activeFactorFilters.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.history),
        actions: [
          if (_assessments != null && _assessments!.length >= 2)
            IconButton(
              icon: Icon(
                _compareMode ? Icons.compare_arrows : Icons.compare_arrows_outlined,
                color: _compareMode ? Theme.of(context).colorScheme.primary : null,
              ),
              tooltip: l.compareEvaluations,
              onPressed: () {
                setState(() {
                  _compareMode = !_compareMode;
                  _selectedForCompare.clear();
                });
              },
            ),
          if (_assessments != null && _assessments!.length >= 2)
            IconButton(
              icon: const Icon(Icons.show_chart),
              tooltip: l.evolutionChart,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EvolutionChartScreen(
                      patient: widget.patient,
                      assessments: _assessments!.reversed.toList(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filters panel
          _buildFiltersPanel(context, l),
          // Compare action bar
          if (_compareMode) _buildCompareBar(context, l),
          // Assessments list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _assessments == null || _assessments!.isEmpty
                    ? _buildEmptyState(context, l)
                    : RefreshIndicator(
                        onRefresh: _loadAssessments,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: _assessments!.length,
                          itemBuilder: (context, index) {
                            final a = _assessments![index];
                            return _buildAssessmentTile(context, a);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel(BuildContext context, AppLocalizations l) {
    final labels = AppConstants.localizedFactorLabels(l);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.filter_list,
              color: _hasActiveFilters
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            title: Text(
              _hasActiveFilters ? l.filtersActive : l.filters,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasActiveFilters)
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(l.clearFilters),
                  ),
                Icon(_filtersExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
              ],
            ),
            onTap: () => setState(() => _filtersExpanded = !_filtersExpanded),
          ),
          if (_filtersExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  // Risk category filter
                  Text(l.riskCategory,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l.all),
                        selected: _riskFilter == null,
                        onSelected: (_) {
                          setState(() => _riskFilter = null);
                          _loadAssessments();
                        },
                      ),
                      ChoiceChip(
                        label: Text(l.highRisk),
                        selected: _riskFilter == 'high',
                        selectedColor: AppColors.highRisk.withAlpha(50),
                        onSelected: (_) {
                          setState(() => _riskFilter = 'high');
                          _loadAssessments();
                        },
                      ),
                      ChoiceChip(
                        label: Text(l.lowRisk),
                        selected: _riskFilter == 'low',
                        selectedColor: AppColors.lowRisk.withAlpha(50),
                        onSelected: (_) {
                          setState(() => _riskFilter = 'low');
                          _loadAssessments();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Date range filter
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
                              _loadAssessments();
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
                              _loadAssessments();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Factor filters
                  Text(l.activeFactors,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: labels.entries.map((e) {
                      final selected = _activeFactorFilters.contains(e.key);
                      return FilterChip(
                        label: Text(e.value, style: const TextStyle(fontSize: 12)),
                        selected: selected,
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              _activeFactorFilters.add(e.key);
                            } else {
                              _activeFactorFilters.remove(e.key);
                            }
                          });
                          _loadAssessments();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompareBar(BuildContext context, AppLocalizations l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
      child: Row(
        children: [
          const Icon(Icons.compare_arrows, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.selectAssessmentsCount(_selectedForCompare.length),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (_selectedForCompare.length == 2)
            FilledButton.tonal(
              onPressed: _openComparison,
              child: Text(l.compare),
            ),
        ],
      ),
    );
  }

  void _openComparison() {
    final ids = _selectedForCompare.toList();
    final a = _assessments!.firstWhere((e) => e.id == ids[0]);
    final b = _assessments!.firstWhere((e) => e.id == ids[1]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComparisonScreen(
          patient: widget.patient,
          assessmentA: a,
          assessmentB: b,
        ),
      ),
    );
  }

  Widget _buildAssessmentTile(BuildContext context, CognitiveAssessment a) {
    final color =
        a.riskCategory == RiskCategory.high ? AppColors.highRisk : AppColors.lowRisk;
    final isSelected = _selectedForCompare.contains(a.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withAlpha(60)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Text(
            '${a.totalScore}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Text('Score: ${a.totalScore}/59  '),
            RiskIndicator(category: a.riskCategory, size: 10),
          ],
        ),
        subtitle: Text(
          '${a.createdAt.day}/${a.createdAt.month}/${a.createdAt.year}'
          '${a.version > 1 ? "  (v${a.version})" : ""}',
        ),
        trailing: _compareMode
            ? Checkbox(
                value: isSelected,
                onChanged: (v) {
                  setState(() {
                    if (v == true && _selectedForCompare.length < 2) {
                      _selectedForCompare.add(a.id!);
                    } else {
                      _selectedForCompare.remove(a.id);
                    }
                  });
                },
              )
            : const Icon(Icons.chevron_right),
        onTap: _compareMode
            ? () {
                setState(() {
                  if (isSelected) {
                    _selectedForCompare.remove(a.id);
                  } else if (_selectedForCompare.length < 2) {
                    _selectedForCompare.add(a.id!);
                  }
                });
              }
            : () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AssessmentDetailScreen(
                      patient: widget.patient,
                      assessment: a,
                    ),
                  ),
                );
                _loadAssessments();
              },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            _hasActiveFilters
                ? l.noResultsWithFilters
                : l.noAssessments,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (_hasActiveFilters)
            TextButton(
              onPressed: _clearFilters,
              child: Text(l.clearAllFilters),
            ),
        ],
      ),
    );
  }
}
