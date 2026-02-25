import '../l10n/generated/app_localizations.dart';

abstract class AppConstants {
  static const String appName = 'Escala de Riesgo Neurocognitivo';
  static const String appVersion = '1.0.0';
  static const String dbName = 'neurocognitive_risk.db';
  static const int dbVersion = 1;
  static const String pdfFooter =
      'Generado por ERN — Esquivel Tamayo JA, Montoya Pedrón A. Rev Mex Neurociencias 2025;26(5) — Solo para uso clínico';

  static const Map<String, String> factorLabels = {
    'lowCompetence': 'Bajo nivel de competencias',
    'hypertension': 'Hipertensión arterial',
    'covid': 'COVID-19',
    'lowEducation': 'Bajo nivel de escolaridad',
    'obesity': 'Obesidad',
    'diabetes': 'Diabetes mellitus',
    'weightLoss': 'Pérdida de peso',
    'inactivity': 'Inactividad física',
    'smoking': 'Tabaquismo',
  };

  /// Factor labels localized via i18n.
  static Map<String, String> localizedFactorLabels(AppLocalizations l) => {
    'lowCompetence': l.lowCompetence,
    'hypertension': l.hypertension,
    'covid': l.covid,
    'lowEducation': l.lowEducation,
    'obesity': l.obesity,
    'diabetes': l.diabetes,
    'weightLoss': l.weightLoss,
    'inactivity': l.inactivity,
    'smoking': l.smoking,
  };
}
