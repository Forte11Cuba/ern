enum RiskCategory {
  low,
  high;

  String get label {
    switch (this) {
      case RiskCategory.low:
        return 'Bajo riesgo';
      case RiskCategory.high:
        return 'Alto riesgo';
    }
  }

  static RiskCategory fromString(String value) {
    switch (value) {
      case 'high':
        return RiskCategory.high;
      default:
        return RiskCategory.low;
    }
  }
}
