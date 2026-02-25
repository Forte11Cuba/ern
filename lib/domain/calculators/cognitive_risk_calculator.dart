import '../entities/cognitive_input.dart';
import '../enums/risk_category.dart';

class CognitiveRiskCalculator {
  static const int cutoff = 33;
  static const int maxScore = 59;

  static const Map<String, int> factorWeights = {
    'lowCompetence': 11,
    'hypertension': 10,
    'covid': 8,
    'lowEducation': 7,
    'obesity': 7,
    'diabetes': 5,
    'weightLoss': 4,
    'inactivity': 4,
    'smoking': 3,
  };

  int calculate(CognitiveInput input) {
    int score = 0;

    if (input.hypertension) score += factorWeights['hypertension']!;
    if (input.lowCompetence) score += factorWeights['lowCompetence']!;
    if (input.lowEducation) score += factorWeights['lowEducation']!;
    if (input.covid) score += factorWeights['covid']!;
    if (input.obesity) score += factorWeights['obesity']!;
    if (input.diabetes) score += factorWeights['diabetes']!;
    if (input.weightLoss) score += factorWeights['weightLoss']!;
    if (input.inactivity) score += factorWeights['inactivity']!;
    if (input.smoking) score += factorWeights['smoking']!;

    return score;
  }

  RiskCategory classify(int score) {
    return score >= cutoff ? RiskCategory.high : RiskCategory.low;
  }

  /// Validates that a stored score matches the factors.
  bool validateIntegrity(CognitiveInput input, int storedScore) {
    return calculate(input) == storedScore;
  }
}
