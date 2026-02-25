import '../enums/risk_category.dart';

class RecommendationService {
  String generate(RiskCategory category) {
    if (category == RiskCategory.high) {
      return 'Paciente clasificado como ALTO RIESGO de deterioro neurocognitivo.\n'
          'Se recomienda:\n\n'
          '\u2022 Evaluación neuropsicológica formal\n'
          '\u2022 Control estricto de factores cardiovasculares\n'
          '\u2022 Intervención sobre estilo de vida\n'
          '\u2022 Seguimiento periódico';
    }

    return 'Paciente clasificado como BAJO RIESGO.\n'
        'Se recomienda:\n\n'
        '\u2022 Mantener hábitos saludables\n'
        '\u2022 Reevaluación periódica';
  }

  /// Returns the recommended reevaluation interval in months.
  int reevaluationIntervalMonths(RiskCategory category) {
    return category == RiskCategory.high ? 3 : 12;
  }
}
