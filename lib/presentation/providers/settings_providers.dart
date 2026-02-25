import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final hasSeenOnboardingProvider = StateProvider<bool>((ref) => false);

final localeProvider = StateProvider<Locale>((ref) => const Locale('es'));

/// Font scale factor: 0.85 (small), 1.0 (medium), 1.15 (large)
final fontScaleProvider = StateProvider<double>((ref) => 1.0);

final highContrastProvider = StateProvider<bool>((ref) => false);
