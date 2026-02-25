import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/reevaluation_reminder.dart';
import '../../providers/database_providers.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<ReevaluationReminder> _pending = [];
  List<ReevaluationReminder> _overdue = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReminders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    setState(() => _loading = true);
    final repo = ref.read(reminderRepositoryProvider);
    final pending = await repo.getPending();
    final overdue = await repo.getOverdue();
    setState(() {
      _pending = pending;
      _overdue = overdue;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reminders),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '${l.pending} (${_pending.length})',
              icon: const Icon(Icons.schedule),
            ),
            Tab(
              text: '${l.overdue} (${_overdue.length})',
              icon: const Icon(Icons.warning_amber),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(l, _pending, isOverdue: false),
                _buildList(l, _overdue, isOverdue: true),
              ],
            ),
    );
  }

  Widget _buildList(AppLocalizations l, List<ReevaluationReminder> reminders,
      {required bool isOverdue}) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOverdue ? Icons.check_circle_outline : Icons.notifications_none,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              isOverdue ? l.noOverdueReminders : l.noPendingReminders,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final r = reminders[index];
          return _ReminderCard(
            reminder: r,
            isOverdue: isOverdue,
            onComplete: () => _markCompleted(r),
          );
        },
      ),
    );
  }

  Future<void> _markCompleted(ReevaluationReminder reminder) async {
    final l = AppLocalizations.of(context)!;
    final repo = ref.read(reminderRepositoryProvider);
    await repo.markCompleted(reminder.id!);
    _loadReminders();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.reminderCompleted),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

class _ReminderCard extends StatelessWidget {
  final ReevaluationReminder reminder;
  final bool isOverdue;
  final VoidCallback onComplete;

  const _ReminderCard({
    required this.reminder,
    required this.isOverdue,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final daysUntil =
        reminder.scheduledDate.difference(DateTime.now()).inDays;
    final color = isOverdue ? AppColors.highRisk : AppColors.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(
            isOverdue ? Icons.warning_amber : Icons.calendar_today,
            color: color,
          ),
        ),
        title: Text(
          '${l.patients} #${reminder.patientId}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l.scheduledFor}: ${reminder.scheduledDate.day}/${reminder.scheduledDate.month}/${reminder.scheduledDate.year}',
            ),
            Text(
              isOverdue
                  ? l.overdueDays(daysUntil.abs())
                  : l.inDays(daysUntil, reminder.intervalMonths),
              style: TextStyle(
                color: isOverdue ? AppColors.highRisk : null,
                fontWeight: isOverdue ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          color: Colors.green,
          tooltip: l.markCompleted,
          onPressed: onComplete,
        ),
      ),
    );
  }
}
