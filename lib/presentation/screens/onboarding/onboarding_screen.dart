import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';
import '../../providers/settings_providers.dart';
import '../dashboard/dashboard_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final AnimationController _buttonController;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _staggerController.forward();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _buttonController.forward().then((_) {
          if (mounted) _buttonController.reverse();
        });
      }
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientAlphaStart = isDark ? 20 : 10;
    final gradientAlphaEnd = isDark ? 30 : 15;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withAlpha(gradientAlphaStart),
              AppColors.primary.withAlpha(gradientAlphaEnd),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/app_icon.png'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l.appName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l.onboardingDescription,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.aboutTheScale,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        l.scoreRange,
                        '0 - ${CognitiveRiskCalculator.maxScore}',
                      ),
                      _buildInfoRow(
                        context,
                        l.cutoffPoint,
                        '${CognitiveRiskCalculator.cutoff}',
                      ),
                      _buildInfoRow(
                        context,
                        l.classification,
                        l.twoCategories,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        l.evaluatedFactors,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      _factorItem(
                          context, l.lowCompetence, 'lowCompetence', 0),
                      _factorItem(context, l.hypertension, 'hypertension', 1),
                      _factorItem(context, l.covid, 'covid', 2),
                      _factorItem(context, l.lowEducation, 'lowEducation', 3),
                      _factorItem(context, l.obesity, 'obesity', 4),
                      _factorItem(context, l.diabetes, 'diabetes', 5),
                      _factorItem(context, l.weightLoss, 'weightLoss', 6),
                      _factorItem(context, l.inactivity, 'inactivity', 7),
                      _factorItem(context, l.smoking, 'smoking', 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ScaleTransition(
                scale: _buttonScale,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_seen_onboarding', true);
                      ref.read(hasSeenOnboardingProvider.notifier).state = true;
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const DashboardScreen()),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l.startButton),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _factorItem(
      BuildContext context, String label, String key, int index) {
    const totalFactors = 9;
    final intervalStart = index / (totalFactors + 2);
    final intervalEnd = (index + 2) / (totalFactors + 2);

    final animation = CurvedAnimation(
      parent: _staggerController,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(-30 * (1 - animation.value), 0),
        child: Opacity(
          opacity: animation.value,
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '$label (${CognitiveRiskCalculator.factorWeights[key]} pts)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(label,
                  style: Theme.of(context).textTheme.bodyMedium)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}
