import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cognitive_assessment.dart';
import '../../domain/entities/cognitive_input.dart';
import '../../domain/calculators/cognitive_risk_calculator.dart';
import '../../domain/enums/risk_category.dart';
import 'database_providers.dart';

final calculatorProvider = Provider<CognitiveRiskCalculator>((ref) {
  return CognitiveRiskCalculator();
});

final assessmentsByPatientProvider =
    FutureProvider.family<List<CognitiveAssessment>, int>((ref, patientId) async {
  final repo = ref.watch(assessmentRepositoryProvider);
  return repo.getByPatientId(patientId);
});

final latestAssessmentProvider =
    FutureProvider.family<CognitiveAssessment?, int>((ref, patientId) async {
  final repo = ref.watch(assessmentRepositoryProvider);
  return repo.getLatestByPatientId(patientId);
});

/// Holds the current form state for a new/edit assessment.
class AssessmentFormNotifier extends StateNotifier<CognitiveInput> {
  final CognitiveRiskCalculator _calculator;

  AssessmentFormNotifier(this._calculator) : super(const CognitiveInput());

  int get currentScore => _calculator.calculate(state);
  RiskCategory get currentCategory => _calculator.classify(currentScore);

  void toggleHypertension(bool v) =>
      state = state.copyWith(hypertension: v);
  void toggleLowCompetence(bool v) =>
      state = state.copyWith(lowCompetence: v);
  void toggleLowEducation(bool v) =>
      state = state.copyWith(lowEducation: v);
  void toggleCovid(bool v) => state = state.copyWith(covid: v);
  void toggleObesity(bool v) => state = state.copyWith(obesity: v);
  void toggleDiabetes(bool v) => state = state.copyWith(diabetes: v);
  void toggleWeightLoss(bool v) => state = state.copyWith(weightLoss: v);
  void toggleInactivity(bool v) => state = state.copyWith(inactivity: v);
  void toggleSmoking(bool v) => state = state.copyWith(smoking: v);

  void loadFromAssessment(CognitiveAssessment assessment) {
    state = CognitiveInput(
      hypertension: assessment.hypertension,
      lowCompetence: assessment.lowCompetence,
      lowEducation: assessment.lowEducation,
      covid: assessment.covid,
      obesity: assessment.obesity,
      diabetes: assessment.diabetes,
      weightLoss: assessment.weightLoss,
      inactivity: assessment.inactivity,
      smoking: assessment.smoking,
    );
  }

  void reset() => state = const CognitiveInput();
}

final assessmentFormProvider =
    StateNotifierProvider<AssessmentFormNotifier, CognitiveInput>((ref) {
  final calculator = ref.watch(calculatorProvider);
  return AssessmentFormNotifier(calculator);
});
