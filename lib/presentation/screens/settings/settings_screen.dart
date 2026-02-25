import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../providers/settings_providers.dart';
import '../about/about_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final highContrast = ref.watch(highContrastProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _SectionHeader(title: l.appearance),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.theme),
            subtitle: Text(_themeModeLabel(l, themeMode)),
            onTap: () => _showThemeDialog(context, ref, l),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            subtitle: Text(locale.languageCode == 'es' ? l.spanish : l.english),
            onTap: () => _showLanguageDialog(context, ref, l),
          ),
          const Divider(),
          _SectionHeader(title: l.accessibility),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: Text(l.fontSize),
            subtitle: Text(_fontScaleLabel(l, fontScale)),
            onTap: () => _showFontDialog(context, ref, l),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.contrast),
            title: Text(l.highContrast),
            subtitle: Text(l.highContrastSubtitle),
            value: highContrast,
            onChanged: (v) =>
                ref.read(highContrastProvider.notifier).state = v,
          ),
          const Divider(),
          _SectionHeader(title: l.information),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            subtitle: Text(l.aboutSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l.version),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(AppLocalizations l, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l.themeLight;
      case ThemeMode.dark:
        return l.themeDark;
      case ThemeMode.system:
        return l.themeSystem;
    }
  }

  String _fontScaleLabel(AppLocalizations l, double scale) {
    if (scale <= 0.85) return l.fontSmall;
    if (scale >= 1.15) return l.fontLarge;
    return l.fontMedium;
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppLocalizations l) {
    final current = ref.read(themeModeProvider);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.selectTheme),
        children: [
          RadioListTile<ThemeMode>(
            title: Text(l.themeLight),
            value: ThemeMode.light,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(themeModeProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l.themeDark),
            value: ThemeMode.dark,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(themeModeProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(l.themeSystem),
            value: ThemeMode.system,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(themeModeProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l) {
    final current = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.language),
        children: [
          RadioListTile<Locale>(
            title: Text(l.spanish),
            value: const Locale('es'),
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(localeProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
          RadioListTile<Locale>(
            title: Text(l.english),
            value: const Locale('en'),
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(localeProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showFontDialog(BuildContext context, WidgetRef ref, AppLocalizations l) {
    final current = ref.read(fontScaleProvider);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.fontSize),
        children: [
          RadioListTile<double>(
            title: Text(l.fontSmall),
            value: 0.85,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(fontScaleProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
          RadioListTile<double>(
            title: Text(l.fontMedium),
            value: 1.0,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(fontScaleProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
          RadioListTile<double>(
            title: Text(l.fontLarge),
            value: 1.15,
            groupValue: current,
            onChanged: (v) {
              if (v != null) ref.read(fontScaleProvider.notifier).state = v;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
