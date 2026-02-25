import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Neurocognitive Risk Scale';

  @override
  String get scaleFormalName => 'Predictive Scale for Mild Neurocognitive Disorder due to Alzheimer\'s Disease';

  @override
  String get dashboard => 'Summary';

  @override
  String get patients => 'Patients';

  @override
  String get analytics => 'Analytics';

  @override
  String get reminders => 'Reminders';

  @override
  String get exportData => 'Export data';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get newAssessment => 'New assessment';

  @override
  String get editAssessment => 'Edit assessment';

  @override
  String get saveAssessment => 'Save assessment';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get result => 'Result';

  @override
  String get history => 'History';

  @override
  String get search => 'Search';

  @override
  String get filters => 'Filters';

  @override
  String get clearFilters => 'Clear';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get totalPatients => 'Patients';

  @override
  String get totalAssessments => 'Assessments';

  @override
  String get highRisk => 'High risk';

  @override
  String get lowRisk => 'Low risk';

  @override
  String get score => 'Score';

  @override
  String get category => 'Category';

  @override
  String get version => 'Version';

  @override
  String get average => 'Average';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get patientsSubtitle => 'View, search or register patients';

  @override
  String get analyticsSubtitle => 'Distribution, trends and correlations';

  @override
  String get remindersSubtitle => 'Pending and overdue reevaluations';

  @override
  String get exportSubtitle => 'CSV and PDF with filters for research';

  @override
  String get aboutSubtitle => 'Scale, scientific evidence and credits';

  @override
  String get patientCode => 'Patient code';

  @override
  String get patientName => 'Name / Initials';

  @override
  String get age => 'Age';

  @override
  String get sex => 'Sex';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get medicalRecord => 'Medical record';

  @override
  String get notes => 'Notes';

  @override
  String get clinicalNotes => 'Clinical notes';

  @override
  String get required => 'Required';

  @override
  String get invalidAge => 'Invalid age';

  @override
  String get newPatient => 'New patient';

  @override
  String get editPatient => 'Edit patient';

  @override
  String get registerPatient => 'Register patient';

  @override
  String get patientUpdated => 'Patient updated';

  @override
  String get patientRegistered => 'Patient registered';

  @override
  String get noPatients => 'No patients registered';

  @override
  String get noResults => 'No results';

  @override
  String get searchHint => 'Search by code, name or record...';

  @override
  String get patientData => 'Patient data';

  @override
  String get assessments => 'Assessments';

  @override
  String get noAssessments => 'No assessments yet';

  @override
  String get hypertension => 'Arterial hypertension';

  @override
  String get lowCompetence => 'Low competence level';

  @override
  String get lowEducation => 'Low education level';

  @override
  String get covid => 'COVID-19';

  @override
  String get obesity => 'Obesity';

  @override
  String get diabetes => 'Diabetes mellitus';

  @override
  String get weightLoss => 'Weight loss';

  @override
  String get inactivity => 'Physical inactivity';

  @override
  String get smoking => 'Smoking';

  @override
  String get pts => 'pts';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get riskFactors => 'Risk factors';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get highRiskRecommendation => 'Patient classified as HIGH RISK for neurocognitive decline.\nRecommendations:\n\n• Formal neuropsychological evaluation\n• Strict cardiovascular risk factor control\n• Lifestyle intervention\n• Periodic follow-up';

  @override
  String get lowRiskRecommendation => 'Patient classified as LOW RISK.\nRecommendations:\n\n• Maintain healthy habits\n• Periodic reevaluation';

  @override
  String get pdf => 'PDF';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get pdfAvailableSoon => 'PDF available in next version';

  @override
  String get assessmentDetail => 'Assessment detail';

  @override
  String get versionHistory => 'Version history';

  @override
  String get currentVersion => 'current';

  @override
  String get previousVersions => 'Previous versions';

  @override
  String get changesVsCurrent => 'Changes vs current version:';

  @override
  String get factorsInVersion => 'Factors in this version:';

  @override
  String get noVersions => 'No previous versions';

  @override
  String get compare => 'Compare';

  @override
  String get comparison => 'Comparison';

  @override
  String get compareEvaluations => 'Compare evaluations';

  @override
  String get selectTwoAssessments => 'Select 2 evaluations';

  @override
  String get previous => 'Previous';

  @override
  String get recent => 'Recent';

  @override
  String get factorComparison => 'Factor comparison';

  @override
  String get summary => 'Summary';

  @override
  String get previousAssessment => 'Previous assessment';

  @override
  String get recentAssessment => 'Recent assessment';

  @override
  String get scoreDifference => 'Score difference';

  @override
  String get categoryChange => 'Category change';

  @override
  String get noChange => 'No change';

  @override
  String get modifiedFactors => 'Modified factors';

  @override
  String get evolutionChart => 'Score evolution';

  @override
  String get cutoff => 'Cutoff';

  @override
  String get date => 'Date';

  @override
  String datePrefix(String date) {
    return 'Date: $date';
  }

  @override
  String get riskCategory => 'Risk category';

  @override
  String get all => 'All';

  @override
  String get dateRange => 'Date range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get activeFactors => 'Active factors';

  @override
  String get noResultsWithFilters => 'No results with applied filters';

  @override
  String get pending => 'Pending';

  @override
  String get overdue => 'Overdue';

  @override
  String get noPendingReminders => 'No pending reminders';

  @override
  String get noOverdueReminders => 'No overdue reminders';

  @override
  String get reminderCompleted => 'Reminder completed';

  @override
  String get markCompleted => 'Mark completed';

  @override
  String get scheduledFor => 'Scheduled';

  @override
  String overdueDays(int days) {
    return 'Overdue by $days days';
  }

  @override
  String inDays(int days, int months) {
    return 'In $days days ($months months)';
  }

  @override
  String get exportFilters => 'Export filters';

  @override
  String get exportFormat => 'Export format';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get csvSubtitle => 'Comma-separated text file';

  @override
  String get statisticsPdf => 'Statistics PDF';

  @override
  String get statisticsPdfSubtitle => 'Aggregate report with distribution and frequencies';

  @override
  String get clearDates => 'Clear dates';

  @override
  String get scoreDistribution => 'Score distribution';

  @override
  String get mostFrequentFactors => 'Most frequent factors';

  @override
  String get temporalTrend => 'Temporal trend';

  @override
  String get factorCorrelation => 'Factor correlation (high risk)';

  @override
  String get commonCombinations => 'Most common combinations in high risk patients';

  @override
  String get noAssessmentsToShow => 'No assessments to show';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get selectTheme => 'Select theme';

  @override
  String get appearance => 'Appearance';

  @override
  String get information => 'Information';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get fontSize => 'Font size';

  @override
  String get fontSmall => 'Small';

  @override
  String get fontMedium => 'Medium';

  @override
  String get fontLarge => 'Large';

  @override
  String get highContrast => 'High contrast';

  @override
  String get highContrastSubtitle => 'Higher contrast for low light use';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get aboutTheScale => 'About the scale';

  @override
  String get scaleDescription => 'Predictive Scale for Mild Neurocognitive Disorder due to Alzheimer\'s Disease. A clinical tool designed to assess the risk of neurocognitive decline in patients through 9 binary risk factors.';

  @override
  String get scaleParameters => 'Scale parameters';

  @override
  String get range => 'Range';

  @override
  String get cutoffPoint => 'Cutoff point';

  @override
  String get categories => 'Categories';

  @override
  String get factors => 'Factors';

  @override
  String get weightsPerFactor => 'Weights per factor';

  @override
  String get points => 'points';

  @override
  String get formulaAuthor => 'Scale author';

  @override
  String get clinicalUseOnly => 'For clinical use only';

  @override
  String get authorName => 'Dr. Julio Antonio Esquivel Tamayo';

  @override
  String get coAuthor => 'Co-author: Arquimedes Montoya Pedron';

  @override
  String get authorContact => 'Contact for advisory';

  @override
  String get scientificEvidence => 'Scientific evidence';

  @override
  String get validationMetrics => 'Performance metrics';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get specificity => 'Specificity';

  @override
  String get ppv => 'PPV';

  @override
  String get npv => 'NPV';

  @override
  String get youdenIndex => 'Youden Index';

  @override
  String get positiveLR => 'Positive likelihood ratio';

  @override
  String get negativeLR => 'Negative likelihood ratio';

  @override
  String get aucRoc => 'AUC-ROC';

  @override
  String get aucRocCI => 'AUC-ROC CI';

  @override
  String get scientificReferences => 'Scientific references';

  @override
  String get citation1 => 'Esquivel Tamayo JA, Montoya Pedron A. Predictive model of mild neurocognitive disorder due to Alzheimer\'s disease in Cuban adults. Revista Mexicana de Neurociencias. 2025; 26(5).';

  @override
  String get citation2 => 'Esquivel Tamayo JA, Montoya Pedron A. Internal validation of a predictive scale for mild neurocognitive disorder due to Alzheimer\'s disease. Archivos de Neurociencias. 2026.';

  @override
  String get viewArticle => 'View article';

  @override
  String get developedBy => 'Developed by';

  @override
  String get developerName => 'Javier Forte';

  @override
  String get developer => 'Developer';

  @override
  String get onboardingDescription => 'Predictive Scale for Mild Neurocognitive Disorder due to Alzheimer\'s Disease, based on 9 risk factors.';

  @override
  String get scoreRange => 'Score range';

  @override
  String get classification => 'Classification';

  @override
  String get twoCategories => '2 categories (Low / High risk)';

  @override
  String get evaluatedFactors => 'Evaluated factors:';

  @override
  String get startButton => 'Get started';

  @override
  String get pdfFooter => 'Generated by NRS — Esquivel Tamayo JA, Montoya Pedron A. Rev Mex Neurociencias 2025;26(5) — For clinical use only';

  @override
  String get clinicalDefinition => 'Clinical definition';

  @override
  String get defLowCompetence => 'Occupations classified at levels 1 and 2 according to the International Standard Classification of Occupations (ISCO-08). Includes manual labor and basic operations.';

  @override
  String get defHypertension => 'Blood pressure readings above 140/90 mmHg recorded on at least 2 occasions with a minimum interval of 6 hours between measurements.';

  @override
  String get defCovid => 'Confirmed COVID-19 diagnosis by biomolecular test (real-time PCR).';

  @override
  String get defLowEducation => 'Primary and secondary education levels according to the Cuban educational system.';

  @override
  String get defObesity => 'Body mass index (BMI) greater than 30 kg/m².';

  @override
  String get defDiabetes => 'Diagnosis based on the criteria: fasting blood glucose ≥126 mg/dL (7.0 mmol/L), 2-hour oral glucose tolerance test ≥200 mg/dL (11.1 mmol/L), glycated hemoglobin (HbA1c) ≥6.5%, or random blood glucose ≥200 mg/dL (11.1 mmol/L) with classic symptoms of hyperglycemia.';

  @override
  String get defWeightLoss => 'Unintentional weight loss of at least 2 kg or 5% of body weight in the last 12 months, not attributable to diet, surgery, or known disease.';

  @override
  String get defInactivity => 'In people aged 18 to 64, it is when the minimum of 150 minutes/week of moderate physical activity (walking, household activities, active games, carrying light weights), 75 minutes/week of vigorous physical activity (cycling, swimming, running, sports, heavy loads, dancing) or an equivalent combination of both is not reached.';

  @override
  String get defSmoking => 'Meets the three DSM-5 criteria for tobacco use disorder: A) consumption of larger amounts than intended over a longer period of time, B) nicotine tolerance (indicated by increasingly larger doses), C) withdrawal symptoms upon discontinuation of use.';

  @override
  String get specificRecommendations => 'Specific recommendations';

  @override
  String get recHypertension => 'Maintain systolic blood pressure at values ≤130 mmHg from age 40 onwards.';

  @override
  String get recLowCompetence => 'Promote participation in cognitively stimulating activities and higher occupational complexity.';

  @override
  String get recLowEducation => 'Facilitate access to educational programs and cognitive stimulation activities.';

  @override
  String get recCovid => 'Perform periodic neurological follow-up in patients with a history of COVID-19.';

  @override
  String get recObesity => 'Maintain a healthy body weight and treat obesity early.';

  @override
  String get recDiabetes => 'Prevent and treat diabetes mellitus, maintain a healthy weight, and engage in regular physical activity.';

  @override
  String get recWeightLoss => 'Monitor nutritional status and rule out underlying causes of unintentional weight loss.';

  @override
  String get recInactivity => 'Incorporate regular physical exercise, ideally at least 150 minutes of moderate aerobic activity per week.';

  @override
  String get recSmoking => 'Reduce tobacco use and participate in smoking cessation counseling programs.';

  @override
  String get filtersActive => 'Filters (active)';

  @override
  String selectAssessmentsCount(int count) {
    return 'Select 2 assessments ($count/2)';
  }

  @override
  String get clearAllFilters => 'Clear filters';

  @override
  String assessmentFromDate(String date) {
    return 'Assessment from $date';
  }

  @override
  String versionEditedDate(int version, String date) {
    return 'Version $version — edited on $date';
  }

  @override
  String versionLabel(int version) {
    return 'Version $version';
  }

  @override
  String editedDate(String date) {
    return 'Edited: $date';
  }

  @override
  String factorChangeToActive(String factor) {
    return '$factor: No → Yes';
  }

  @override
  String factorChangeToInactive(String factor) {
    return '$factor: Yes → No';
  }

  @override
  String notesContent(String content) {
    return 'Notes: $content';
  }

  @override
  String evaluationsCount(int count) {
    return '$count assessments';
  }

  @override
  String get clinicalRecommendation => 'Clinical recommendation';

  @override
  String get aggregateStatistics => 'Aggregate Statistics';

  @override
  String generatedDate(String date) {
    return 'Generated: $date';
  }

  @override
  String get generalSummary => 'General summary';

  @override
  String get totalPatientsLabel => 'Total patients';

  @override
  String get totalAssessmentsLabel => 'Total assessments';

  @override
  String get averageScore => 'Average score';

  @override
  String get factorFrequency => 'Risk factor frequency';

  @override
  String get amount => 'Amount';

  @override
  String get present => 'Present';

  @override
  String get factor => 'Factor';

  @override
  String get nameLabel => 'Name';

  @override
  String get codeLabel => 'Code';

  @override
  String assessmentDateLabel(String date) {
    return 'Assessment date: $date';
  }

  @override
  String versionInParens(int version) {
    return '(Version $version)';
  }

  @override
  String scoreTotalDisplay(int score, int max) {
    return 'Total score: $score / $max';
  }

  @override
  String get assessmentDateHeader => 'Assessment Date';

  @override
  String get totalScoreHeader => 'Total Score';

  @override
  String csvExportSubject(String appName) {
    return 'Assessment export - $appName';
  }

  @override
  String get reevaluationPending => 'Pending reevaluation';

  @override
  String reevaluationScheduled(String name) {
    return 'Patient $name has a scheduled reevaluation';
  }
}
