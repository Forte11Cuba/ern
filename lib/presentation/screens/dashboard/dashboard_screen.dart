import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/dashboard_providers.dart';
import '../../widgets/stat_card.dart';
import '../patients/patients_list_screen.dart';
import '../settings/settings_screen.dart';
import '../about/about_screen.dart';
import '../reminders/reminders_screen.dart';
import '../export/export_screen.dart';
import '../analytics/analytics_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _staggeredItem(int index, int total, Widget child) {
    final intervalStart = index / (total + 2);
    final intervalEnd = (index + 2) / (total + 2);
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
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _hasAnimated = false;
          ref.invalidate(dashboardStatsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            Text(
              l.dashboard,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) {
                if (!_hasAnimated) {
                  _hasAnimated = true;
                  _staggerController.forward(from: 0);
                }
                return _buildStatsGrid(context, stats, l);
              },
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${l.error}: $e'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.quickAccess,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _staggeredItem(
              4,
              9,
              _buildQuickAction(
                context,
                icon: Icons.people_outline,
                title: l.patients,
                subtitle: l.patientsSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const PatientsListScreen()),
                ),
              ),
            ),
            _staggeredItem(
              5,
              9,
              _buildQuickAction(
                context,
                icon: Icons.bar_chart,
                title: l.analytics,
                subtitle: l.analyticsSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const AnalyticsScreen()),
                ),
              ),
            ),
            _staggeredItem(
              6,
              9,
              _buildQuickAction(
                context,
                icon: Icons.notifications_outlined,
                title: l.reminders,
                subtitle: l.remindersSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const RemindersScreen()),
                ),
              ),
            ),
            _staggeredItem(
              7,
              9,
              _buildQuickAction(
                context,
                icon: Icons.download_outlined,
                title: l.exportData,
                subtitle: l.exportSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const ExportScreen()),
                ),
              ),
            ),
            _staggeredItem(
              8,
              9,
              _buildQuickAction(
                context,
                icon: Icons.info_outline,
                title: l.about,
                subtitle: l.aboutSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PatientsListScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l.newAssessment),
      ),
    );
  }

  Widget _buildStatsGrid(
      BuildContext context, DashboardStats stats, AppLocalizations l) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: [
        _staggeredItem(
          0,
          9,
          StatCard(
            title: l.totalPatients,
            value: '${stats.totalPatients}',
            icon: Icons.people,
            color: AppColors.primary,
          ),
        ),
        _staggeredItem(
          1,
          9,
          StatCard(
            title: l.totalAssessments,
            value: '${stats.totalAssessments}',
            icon: Icons.assignment,
            color: AppColors.primary,
          ),
        ),
        _staggeredItem(
          2,
          9,
          StatCard(
            title: l.highRisk,
            value: '${stats.highRiskCount}',
            icon: Icons.warning_amber,
            color: AppColors.highRisk,
          ),
        ),
        _staggeredItem(
          3,
          9,
          StatCard(
            title: l.lowRisk,
            value: '${stats.lowRiskCount}',
            icon: Icons.check_circle_outline,
            color: AppColors.lowRisk,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
