import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Escala de Riesgo Neurocognitivo'**
  String get appName;

  /// No description provided for @scaleFormalName.
  ///
  /// In es, this message translates to:
  /// **'Escala predictiva de Trastorno Neurocognitivo Leve debido a la Enfermedad de Alzheimer'**
  String get scaleFormalName;

  /// No description provided for @dashboard.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get dashboard;

  /// No description provided for @patients.
  ///
  /// In es, this message translates to:
  /// **'Pacientes'**
  String get patients;

  /// No description provided for @analytics.
  ///
  /// In es, this message translates to:
  /// **'Analíticas'**
  String get analytics;

  /// No description provided for @reminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios'**
  String get reminders;

  /// No description provided for @exportData.
  ///
  /// In es, this message translates to:
  /// **'Exportar datos'**
  String get exportData;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @newAssessment.
  ///
  /// In es, this message translates to:
  /// **'Nueva evaluación'**
  String get newAssessment;

  /// No description provided for @editAssessment.
  ///
  /// In es, this message translates to:
  /// **'Editar evaluación'**
  String get editAssessment;

  /// No description provided for @saveAssessment.
  ///
  /// In es, this message translates to:
  /// **'Guardar evaluación'**
  String get saveAssessment;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @result.
  ///
  /// In es, this message translates to:
  /// **'Resultado'**
  String get result;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @clearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clearFilters;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @totalPatients.
  ///
  /// In es, this message translates to:
  /// **'Pacientes'**
  String get totalPatients;

  /// No description provided for @totalAssessments.
  ///
  /// In es, this message translates to:
  /// **'Evaluaciones'**
  String get totalAssessments;

  /// No description provided for @highRisk.
  ///
  /// In es, this message translates to:
  /// **'Alto riesgo'**
  String get highRisk;

  /// No description provided for @lowRisk.
  ///
  /// In es, this message translates to:
  /// **'Bajo riesgo'**
  String get lowRisk;

  /// No description provided for @score.
  ///
  /// In es, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get version;

  /// No description provided for @average.
  ///
  /// In es, this message translates to:
  /// **'Promedio'**
  String get average;

  /// No description provided for @quickAccess.
  ///
  /// In es, this message translates to:
  /// **'Acceso rápido'**
  String get quickAccess;

  /// No description provided for @patientsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ver lista, buscar o registrar pacientes'**
  String get patientsSubtitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Distribución, tendencias y correlaciones'**
  String get analyticsSubtitle;

  /// No description provided for @remindersSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reevaluaciones pendientes y vencidas'**
  String get remindersSubtitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In es, this message translates to:
  /// **'CSV y PDF con filtros para investigación'**
  String get exportSubtitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Escala, evidencia científica y créditos'**
  String get aboutSubtitle;

  /// No description provided for @patientCode.
  ///
  /// In es, this message translates to:
  /// **'Código del paciente'**
  String get patientCode;

  /// No description provided for @patientName.
  ///
  /// In es, this message translates to:
  /// **'Nombre / Iniciales'**
  String get patientName;

  /// No description provided for @age.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get age;

  /// No description provided for @sex.
  ///
  /// In es, this message translates to:
  /// **'Sexo'**
  String get sex;

  /// No description provided for @male.
  ///
  /// In es, this message translates to:
  /// **'Masculino'**
  String get male;

  /// No description provided for @female.
  ///
  /// In es, this message translates to:
  /// **'Femenino'**
  String get female;

  /// No description provided for @birthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get birthDate;

  /// No description provided for @medicalRecord.
  ///
  /// In es, this message translates to:
  /// **'Historia clínica'**
  String get medicalRecord;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @clinicalNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas clínicas'**
  String get clinicalNotes;

  /// No description provided for @required.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get required;

  /// No description provided for @invalidAge.
  ///
  /// In es, this message translates to:
  /// **'Edad inválida'**
  String get invalidAge;

  /// No description provided for @newPatient.
  ///
  /// In es, this message translates to:
  /// **'Nuevo paciente'**
  String get newPatient;

  /// No description provided for @editPatient.
  ///
  /// In es, this message translates to:
  /// **'Editar paciente'**
  String get editPatient;

  /// No description provided for @registerPatient.
  ///
  /// In es, this message translates to:
  /// **'Registrar paciente'**
  String get registerPatient;

  /// No description provided for @patientUpdated.
  ///
  /// In es, this message translates to:
  /// **'Paciente actualizado'**
  String get patientUpdated;

  /// No description provided for @patientRegistered.
  ///
  /// In es, this message translates to:
  /// **'Paciente registrado'**
  String get patientRegistered;

  /// No description provided for @noPatients.
  ///
  /// In es, this message translates to:
  /// **'No hay pacientes registrados'**
  String get noPatients;

  /// No description provided for @noResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get noResults;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por código, nombre o historia...'**
  String get searchHint;

  /// No description provided for @patientData.
  ///
  /// In es, this message translates to:
  /// **'Datos del paciente'**
  String get patientData;

  /// No description provided for @assessments.
  ///
  /// In es, this message translates to:
  /// **'Evaluaciones'**
  String get assessments;

  /// No description provided for @noAssessments.
  ///
  /// In es, this message translates to:
  /// **'Sin evaluaciones aún'**
  String get noAssessments;

  /// No description provided for @hypertension.
  ///
  /// In es, this message translates to:
  /// **'Hipertensión arterial'**
  String get hypertension;

  /// No description provided for @lowCompetence.
  ///
  /// In es, this message translates to:
  /// **'Bajo nivel de competencias'**
  String get lowCompetence;

  /// No description provided for @lowEducation.
  ///
  /// In es, this message translates to:
  /// **'Bajo nivel de escolaridad'**
  String get lowEducation;

  /// No description provided for @covid.
  ///
  /// In es, this message translates to:
  /// **'COVID-19'**
  String get covid;

  /// No description provided for @obesity.
  ///
  /// In es, this message translates to:
  /// **'Obesidad'**
  String get obesity;

  /// No description provided for @diabetes.
  ///
  /// In es, this message translates to:
  /// **'Diabetes mellitus'**
  String get diabetes;

  /// No description provided for @weightLoss.
  ///
  /// In es, this message translates to:
  /// **'Pérdida de peso'**
  String get weightLoss;

  /// No description provided for @inactivity.
  ///
  /// In es, this message translates to:
  /// **'Inactividad física'**
  String get inactivity;

  /// No description provided for @smoking.
  ///
  /// In es, this message translates to:
  /// **'Tabaquismo'**
  String get smoking;

  /// No description provided for @pts.
  ///
  /// In es, this message translates to:
  /// **'pts'**
  String get pts;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @riskFactors.
  ///
  /// In es, this message translates to:
  /// **'Factores de riesgo'**
  String get riskFactors;

  /// No description provided for @recommendation.
  ///
  /// In es, this message translates to:
  /// **'Recomendación'**
  String get recommendation;

  /// No description provided for @highRiskRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Paciente clasificado como ALTO RIESGO de deterioro neurocognitivo.\nSe recomienda:\n\n• Evaluación neuropsicológica formal\n• Control estricto de factores cardiovasculares\n• Intervención sobre estilo de vida\n• Seguimiento periódico'**
  String get highRiskRecommendation;

  /// No description provided for @lowRiskRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Paciente clasificado como BAJO RIESGO.\nSe recomienda:\n\n• Mantener hábitos saludables\n• Reevaluación periódica'**
  String get lowRiskRecommendation;

  /// No description provided for @pdf.
  ///
  /// In es, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @share.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @pdfAvailableSoon.
  ///
  /// In es, this message translates to:
  /// **'PDF disponible en próxima versión'**
  String get pdfAvailableSoon;

  /// No description provided for @assessmentDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle evaluación'**
  String get assessmentDetail;

  /// No description provided for @versionHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de versiones'**
  String get versionHistory;

  /// No description provided for @currentVersion.
  ///
  /// In es, this message translates to:
  /// **'actual'**
  String get currentVersion;

  /// No description provided for @previousVersions.
  ///
  /// In es, this message translates to:
  /// **'Versiones anteriores'**
  String get previousVersions;

  /// No description provided for @changesVsCurrent.
  ///
  /// In es, this message translates to:
  /// **'Cambios respecto a versión actual:'**
  String get changesVsCurrent;

  /// No description provided for @factorsInVersion.
  ///
  /// In es, this message translates to:
  /// **'Factores en esta versión:'**
  String get factorsInVersion;

  /// No description provided for @noVersions.
  ///
  /// In es, this message translates to:
  /// **'No hay versiones anteriores'**
  String get noVersions;

  /// No description provided for @compare.
  ///
  /// In es, this message translates to:
  /// **'Comparar'**
  String get compare;

  /// No description provided for @comparison.
  ///
  /// In es, this message translates to:
  /// **'Comparativa'**
  String get comparison;

  /// No description provided for @compareEvaluations.
  ///
  /// In es, this message translates to:
  /// **'Comparar evaluaciones'**
  String get compareEvaluations;

  /// No description provided for @selectTwoAssessments.
  ///
  /// In es, this message translates to:
  /// **'Selecciona 2 evaluaciones'**
  String get selectTwoAssessments;

  /// No description provided for @previous.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @recent.
  ///
  /// In es, this message translates to:
  /// **'Reciente'**
  String get recent;

  /// No description provided for @factorComparison.
  ///
  /// In es, this message translates to:
  /// **'Comparativa de factores'**
  String get factorComparison;

  /// No description provided for @summary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @previousAssessment.
  ///
  /// In es, this message translates to:
  /// **'Evaluación anterior'**
  String get previousAssessment;

  /// No description provided for @recentAssessment.
  ///
  /// In es, this message translates to:
  /// **'Evaluación reciente'**
  String get recentAssessment;

  /// No description provided for @scoreDifference.
  ///
  /// In es, this message translates to:
  /// **'Diferencia de score'**
  String get scoreDifference;

  /// No description provided for @categoryChange.
  ///
  /// In es, this message translates to:
  /// **'Cambio de categoría'**
  String get categoryChange;

  /// No description provided for @noChange.
  ///
  /// In es, this message translates to:
  /// **'Sin cambio'**
  String get noChange;

  /// No description provided for @modifiedFactors.
  ///
  /// In es, this message translates to:
  /// **'Factores modificados'**
  String get modifiedFactors;

  /// No description provided for @evolutionChart.
  ///
  /// In es, this message translates to:
  /// **'Evolución del score'**
  String get evolutionChart;

  /// No description provided for @cutoff.
  ///
  /// In es, this message translates to:
  /// **'Corte'**
  String get cutoff;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @datePrefix.
  ///
  /// In es, this message translates to:
  /// **'Fecha: {date}'**
  String datePrefix(String date);

  /// No description provided for @riskCategory.
  ///
  /// In es, this message translates to:
  /// **'Categoría de riesgo'**
  String get riskCategory;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @dateRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de fechas'**
  String get dateRange;

  /// No description provided for @from.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get from;

  /// No description provided for @to.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get to;

  /// No description provided for @activeFactors.
  ///
  /// In es, this message translates to:
  /// **'Factores presentes'**
  String get activeFactors;

  /// No description provided for @noResultsWithFilters.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados con los filtros aplicados'**
  String get noResultsWithFilters;

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pending;

  /// No description provided for @overdue.
  ///
  /// In es, this message translates to:
  /// **'Vencidos'**
  String get overdue;

  /// No description provided for @noPendingReminders.
  ///
  /// In es, this message translates to:
  /// **'No hay recordatorios pendientes'**
  String get noPendingReminders;

  /// No description provided for @noOverdueReminders.
  ///
  /// In es, this message translates to:
  /// **'No hay recordatorios vencidos'**
  String get noOverdueReminders;

  /// No description provided for @reminderCompleted.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio completado'**
  String get reminderCompleted;

  /// No description provided for @markCompleted.
  ///
  /// In es, this message translates to:
  /// **'Marcar completado'**
  String get markCompleted;

  /// No description provided for @scheduledFor.
  ///
  /// In es, this message translates to:
  /// **'Programada'**
  String get scheduledFor;

  /// No description provided for @overdueDays.
  ///
  /// In es, this message translates to:
  /// **'Vencida hace {days} días'**
  String overdueDays(int days);

  /// No description provided for @inDays.
  ///
  /// In es, this message translates to:
  /// **'En {days} días ({months} meses)'**
  String inDays(int days, int months);

  /// No description provided for @exportFilters.
  ///
  /// In es, this message translates to:
  /// **'Filtros de exportación'**
  String get exportFilters;

  /// No description provided for @exportFormat.
  ///
  /// In es, this message translates to:
  /// **'Formato de exportación'**
  String get exportFormat;

  /// No description provided for @exportCsv.
  ///
  /// In es, this message translates to:
  /// **'Exportar CSV'**
  String get exportCsv;

  /// No description provided for @csvSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Archivo de texto separado por comas'**
  String get csvSubtitle;

  /// No description provided for @statisticsPdf.
  ///
  /// In es, this message translates to:
  /// **'PDF de estadísticas'**
  String get statisticsPdf;

  /// No description provided for @statisticsPdfSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reporte agregado con distribución y frecuencias'**
  String get statisticsPdfSubtitle;

  /// No description provided for @clearDates.
  ///
  /// In es, this message translates to:
  /// **'Limpiar fechas'**
  String get clearDates;

  /// No description provided for @scoreDistribution.
  ///
  /// In es, this message translates to:
  /// **'Distribución de scores'**
  String get scoreDistribution;

  /// No description provided for @mostFrequentFactors.
  ///
  /// In es, this message translates to:
  /// **'Factores más frecuentes'**
  String get mostFrequentFactors;

  /// No description provided for @temporalTrend.
  ///
  /// In es, this message translates to:
  /// **'Tendencia temporal'**
  String get temporalTrend;

  /// No description provided for @factorCorrelation.
  ///
  /// In es, this message translates to:
  /// **'Correlación de factores (alto riesgo)'**
  String get factorCorrelation;

  /// No description provided for @commonCombinations.
  ///
  /// In es, this message translates to:
  /// **'Combinaciones más comunes en pacientes de alto riesgo'**
  String get commonCombinations;

  /// No description provided for @noAssessmentsToShow.
  ///
  /// In es, this message translates to:
  /// **'No hay evaluaciones para mostrar'**
  String get noAssessmentsToShow;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @selectTheme.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tema'**
  String get selectTheme;

  /// No description provided for @appearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearance;

  /// No description provided for @information.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get information;

  /// No description provided for @accessibility.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get accessibility;

  /// No description provided for @fontSize.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de fuente'**
  String get fontSize;

  /// No description provided for @fontSmall.
  ///
  /// In es, this message translates to:
  /// **'Pequeño'**
  String get fontSmall;

  /// No description provided for @fontMedium.
  ///
  /// In es, this message translates to:
  /// **'Mediano'**
  String get fontMedium;

  /// No description provided for @fontLarge.
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get fontLarge;

  /// No description provided for @highContrast.
  ///
  /// In es, this message translates to:
  /// **'Alto contraste'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Mayor contraste para uso con poca luz'**
  String get highContrastSubtitle;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @aboutTheScale.
  ///
  /// In es, this message translates to:
  /// **'Acerca de la escala'**
  String get aboutTheScale;

  /// No description provided for @scaleDescription.
  ///
  /// In es, this message translates to:
  /// **'Escala predictiva de Trastorno Neurocognitivo Leve debido a la Enfermedad de Alzheimer. Herramienta clínica para evaluar el riesgo de deterioro neurocognitivo en pacientes a través de 9 factores de riesgo binarios.'**
  String get scaleDescription;

  /// No description provided for @scaleParameters.
  ///
  /// In es, this message translates to:
  /// **'Parámetros de la escala'**
  String get scaleParameters;

  /// No description provided for @range.
  ///
  /// In es, this message translates to:
  /// **'Rango'**
  String get range;

  /// No description provided for @cutoffPoint.
  ///
  /// In es, this message translates to:
  /// **'Punto de corte'**
  String get cutoffPoint;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @factors.
  ///
  /// In es, this message translates to:
  /// **'Factores'**
  String get factors;

  /// No description provided for @weightsPerFactor.
  ///
  /// In es, this message translates to:
  /// **'Pesos por factor'**
  String get weightsPerFactor;

  /// No description provided for @points.
  ///
  /// In es, this message translates to:
  /// **'puntos'**
  String get points;

  /// No description provided for @formulaAuthor.
  ///
  /// In es, this message translates to:
  /// **'Autor de la escala'**
  String get formulaAuthor;

  /// No description provided for @clinicalUseOnly.
  ///
  /// In es, this message translates to:
  /// **'Solo para uso clínico'**
  String get clinicalUseOnly;

  /// No description provided for @authorName.
  ///
  /// In es, this message translates to:
  /// **'Dr. Julio Antonio Esquivel Tamayo'**
  String get authorName;

  /// No description provided for @coAuthor.
  ///
  /// In es, this message translates to:
  /// **'Co-autor: Arquímedes Montoya Pedrón'**
  String get coAuthor;

  /// No description provided for @authorContact.
  ///
  /// In es, this message translates to:
  /// **'Contacto para asesoría'**
  String get authorContact;

  /// No description provided for @scientificEvidence.
  ///
  /// In es, this message translates to:
  /// **'Evidencia científica'**
  String get scientificEvidence;

  /// No description provided for @validationMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas de rendimiento'**
  String get validationMetrics;

  /// No description provided for @sensitivity.
  ///
  /// In es, this message translates to:
  /// **'Sensibilidad'**
  String get sensitivity;

  /// No description provided for @specificity.
  ///
  /// In es, this message translates to:
  /// **'Especificidad'**
  String get specificity;

  /// No description provided for @ppv.
  ///
  /// In es, this message translates to:
  /// **'VPP'**
  String get ppv;

  /// No description provided for @npv.
  ///
  /// In es, this message translates to:
  /// **'VPN'**
  String get npv;

  /// No description provided for @youdenIndex.
  ///
  /// In es, this message translates to:
  /// **'Índice de Youden'**
  String get youdenIndex;

  /// No description provided for @positiveLR.
  ///
  /// In es, this message translates to:
  /// **'Razón de verosimilitud (+)'**
  String get positiveLR;

  /// No description provided for @negativeLR.
  ///
  /// In es, this message translates to:
  /// **'Razón de verosimilitud (-)'**
  String get negativeLR;

  /// No description provided for @aucRoc.
  ///
  /// In es, this message translates to:
  /// **'ABCCOR'**
  String get aucRoc;

  /// No description provided for @aucRocCI.
  ///
  /// In es, this message translates to:
  /// **'IC ABCCOR'**
  String get aucRocCI;

  /// No description provided for @scientificReferences.
  ///
  /// In es, this message translates to:
  /// **'Referencias científicas'**
  String get scientificReferences;

  /// No description provided for @citation1.
  ///
  /// In es, this message translates to:
  /// **'Esquivel Tamayo JA, Montoya Pedrón A. Predictive model of mild neurocognitive disorder due to Alzheimer\'s disease in Cuban adults. Revista Mexicana de Neurociencias. 2025; 26(5).'**
  String get citation1;

  /// No description provided for @citation2.
  ///
  /// In es, this message translates to:
  /// **'Esquivel Tamayo JA, Montoya Pedrón A. Validación interna de una escala predictiva de trastorno neurocognitivo leve debido a la enfermedad de Alzheimer. Archivos de Neurociencias. 2026.'**
  String get citation2;

  /// No description provided for @viewArticle.
  ///
  /// In es, this message translates to:
  /// **'Ver artículo'**
  String get viewArticle;

  /// No description provided for @developedBy.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado por'**
  String get developedBy;

  /// No description provided for @developerName.
  ///
  /// In es, this message translates to:
  /// **'Javier Forte'**
  String get developerName;

  /// No description provided for @developer.
  ///
  /// In es, this message translates to:
  /// **'Desarrollador'**
  String get developer;

  /// No description provided for @onboardingDescription.
  ///
  /// In es, this message translates to:
  /// **'Escala predictiva de Trastorno Neurocognitivo Leve debido a la Enfermedad de Alzheimer, basada en 9 factores de riesgo.'**
  String get onboardingDescription;

  /// No description provided for @scoreRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de score'**
  String get scoreRange;

  /// No description provided for @classification.
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get classification;

  /// No description provided for @twoCategories.
  ///
  /// In es, this message translates to:
  /// **'2 categorías (Bajo / Alto riesgo)'**
  String get twoCategories;

  /// No description provided for @evaluatedFactors.
  ///
  /// In es, this message translates to:
  /// **'Factores evaluados:'**
  String get evaluatedFactors;

  /// No description provided for @startButton.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get startButton;

  /// No description provided for @pdfFooter.
  ///
  /// In es, this message translates to:
  /// **'Generado por ERN — Esquivel Tamayo JA, Montoya Pedrón A. Rev Mex Neurociencias 2025;26(5) — Solo para uso clínico'**
  String get pdfFooter;

  /// No description provided for @clinicalDefinition.
  ///
  /// In es, this message translates to:
  /// **'Definición clínica'**
  String get clinicalDefinition;

  /// No description provided for @defLowCompetence.
  ///
  /// In es, this message translates to:
  /// **'Ocupaciones clasificadas en los niveles 1 y 2 según la Clasificación Internacional Uniforme de Ocupaciones (CIUO-08). Incluye trabajos de labor manual y operaciones básicas.'**
  String get defLowCompetence;

  /// No description provided for @defHypertension.
  ///
  /// In es, this message translates to:
  /// **'Cifras de presión arterial superiores a 140/90 mmHg registradas en al menos 2 ocasiones con un intervalo mínimo de 6 horas entre las mediciones.'**
  String get defHypertension;

  /// No description provided for @defCovid.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico confirmado de COVID-19 mediante prueba biomolecular (PCR en tiempo real).'**
  String get defCovid;

  /// No description provided for @defLowEducation.
  ///
  /// In es, this message translates to:
  /// **'Niveles de escolaridad de primaria y secundaria según el sistema educativo cubano.'**
  String get defLowEducation;

  /// No description provided for @defObesity.
  ///
  /// In es, this message translates to:
  /// **'Índice de masa corporal (IMC) superior a 30 kg/m².'**
  String get defObesity;

  /// No description provided for @defDiabetes.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico según los criterios: glucemia en ayunas ≥126 mg/dL (7.0 mmol/L), glucemia a las 2 horas de una prueba de tolerancia oral a la glucosa ≥200 mg/dL (11.1 mmol/L), hemoglobina glucosilada (HbA1c) ≥6.5%, o glucemia al azar ≥200 mg/dL (11.1 mmol/L) con síntomas clásicos de hiperglucemia.'**
  String get defDiabetes;

  /// No description provided for @defWeightLoss.
  ///
  /// In es, this message translates to:
  /// **'Pérdida de peso no intencional de al menos 2 kg o del 5% del peso corporal en los últimos 12 meses, no atribuible a dieta, cirugía o enfermedad conocida.'**
  String get defWeightLoss;

  /// No description provided for @defInactivity.
  ///
  /// In es, this message translates to:
  /// **'En personas entre 18 y 64 años, es cuando no se alcanza el mínimo de 150 minutos/semana de actividad física moderada (caminatas, actividades domésticas, juegos con movimientos, cargar pesos ligeros), 75 minutos/semana de actividad física vigorosa (ciclismo, natación, carreras, deportes, cargas pesadas, bailes) o una combinación equivalente de ambas.'**
  String get defInactivity;

  /// No description provided for @defSmoking.
  ///
  /// In es, this message translates to:
  /// **'Cumple con los tres criterios del DSM-5 para un trastorno por consumo de tabaco: A) consumo de cantidades mayores que las previstas por un período de tiempo más largo, B) tolerancia a la nicotina (indicada por dosis cada vez mayores), C) síntomas de abstinencia al suspender el uso.'**
  String get defSmoking;

  /// No description provided for @specificRecommendations.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones específicas'**
  String get specificRecommendations;

  /// No description provided for @recHypertension.
  ///
  /// In es, this message translates to:
  /// **'Mantener la presión arterial sistólica en valores ≤130 mmHg desde los 40 años de edad.'**
  String get recHypertension;

  /// No description provided for @recLowCompetence.
  ///
  /// In es, this message translates to:
  /// **'Promover la participación en actividades cognitivamente estimulantes y de mayor complejidad ocupacional.'**
  String get recLowCompetence;

  /// No description provided for @recLowEducation.
  ///
  /// In es, this message translates to:
  /// **'Facilitar el acceso a programas educativos y actividades de estimulación cognitiva.'**
  String get recLowEducation;

  /// No description provided for @recCovid.
  ///
  /// In es, this message translates to:
  /// **'Realizar seguimiento neurológico periódico en pacientes con antecedente de COVID-19.'**
  String get recCovid;

  /// No description provided for @recObesity.
  ///
  /// In es, this message translates to:
  /// **'Mantener un peso corporal saludable y tratar la obesidad de forma precoz.'**
  String get recObesity;

  /// No description provided for @recDiabetes.
  ///
  /// In es, this message translates to:
  /// **'Prevenir y tratar la diabetes mellitus, mantener un peso saludable y realizar actividad física regular.'**
  String get recDiabetes;

  /// No description provided for @recWeightLoss.
  ///
  /// In es, this message translates to:
  /// **'Monitorear el estado nutricional y descartar causas subyacentes de pérdida de peso no intencional.'**
  String get recWeightLoss;

  /// No description provided for @recInactivity.
  ///
  /// In es, this message translates to:
  /// **'Incorporar ejercicio físico regular, idealmente actividad aeróbica moderada al menos 150 minutos por semana.'**
  String get recInactivity;

  /// No description provided for @recSmoking.
  ///
  /// In es, this message translates to:
  /// **'Reducir el consumo de tabaco y participar en programas de consejería para la cesación tabáquica.'**
  String get recSmoking;

  /// No description provided for @filtersActive.
  ///
  /// In es, this message translates to:
  /// **'Filtros (activos)'**
  String get filtersActive;

  /// No description provided for @selectAssessmentsCount.
  ///
  /// In es, this message translates to:
  /// **'Selecciona 2 evaluaciones ({count}/2)'**
  String selectAssessmentsCount(int count);

  /// No description provided for @clearAllFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get clearAllFilters;

  /// No description provided for @assessmentFromDate.
  ///
  /// In es, this message translates to:
  /// **'Evaluación del {date}'**
  String assessmentFromDate(String date);

  /// No description provided for @versionEditedDate.
  ///
  /// In es, this message translates to:
  /// **'Versión {version} — editada el {date}'**
  String versionEditedDate(int version, String date);

  /// No description provided for @versionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String versionLabel(int version);

  /// No description provided for @editedDate.
  ///
  /// In es, this message translates to:
  /// **'Editada: {date}'**
  String editedDate(String date);

  /// No description provided for @factorChangeToActive.
  ///
  /// In es, this message translates to:
  /// **'{factor}: No → Sí'**
  String factorChangeToActive(String factor);

  /// No description provided for @factorChangeToInactive.
  ///
  /// In es, this message translates to:
  /// **'{factor}: Sí → No'**
  String factorChangeToInactive(String factor);

  /// No description provided for @notesContent.
  ///
  /// In es, this message translates to:
  /// **'Notas: {content}'**
  String notesContent(String content);

  /// No description provided for @evaluationsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} evaluaciones'**
  String evaluationsCount(int count);

  /// No description provided for @clinicalRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Recomendación clínica'**
  String get clinicalRecommendation;

  /// No description provided for @aggregateStatistics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas Agregadas'**
  String get aggregateStatistics;

  /// No description provided for @generatedDate.
  ///
  /// In es, this message translates to:
  /// **'Generado: {date}'**
  String generatedDate(String date);

  /// No description provided for @generalSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen general'**
  String get generalSummary;

  /// No description provided for @totalPatientsLabel.
  ///
  /// In es, this message translates to:
  /// **'Total de pacientes'**
  String get totalPatientsLabel;

  /// No description provided for @totalAssessmentsLabel.
  ///
  /// In es, this message translates to:
  /// **'Total de evaluaciones'**
  String get totalAssessmentsLabel;

  /// No description provided for @averageScore.
  ///
  /// In es, this message translates to:
  /// **'Score promedio'**
  String get averageScore;

  /// No description provided for @factorFrequency.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia de factores de riesgo'**
  String get factorFrequency;

  /// No description provided for @amount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get amount;

  /// No description provided for @present.
  ///
  /// In es, this message translates to:
  /// **'Presente'**
  String get present;

  /// No description provided for @factor.
  ///
  /// In es, this message translates to:
  /// **'Factor'**
  String get factor;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nameLabel;

  /// No description provided for @codeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get codeLabel;

  /// No description provided for @assessmentDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de evaluación: {date}'**
  String assessmentDateLabel(String date);

  /// No description provided for @versionInParens.
  ///
  /// In es, this message translates to:
  /// **'(Versión {version})'**
  String versionInParens(int version);

  /// No description provided for @scoreTotalDisplay.
  ///
  /// In es, this message translates to:
  /// **'Score total: {score} / {max}'**
  String scoreTotalDisplay(int score, int max);

  /// No description provided for @assessmentDateHeader.
  ///
  /// In es, this message translates to:
  /// **'Fecha Evaluación'**
  String get assessmentDateHeader;

  /// No description provided for @totalScoreHeader.
  ///
  /// In es, this message translates to:
  /// **'Score Total'**
  String get totalScoreHeader;

  /// No description provided for @csvExportSubject.
  ///
  /// In es, this message translates to:
  /// **'Exportación de evaluaciones - {appName}'**
  String csvExportSubject(String appName);

  /// No description provided for @reevaluationPending.
  ///
  /// In es, this message translates to:
  /// **'Reevaluación pendiente'**
  String get reevaluationPending;

  /// No description provided for @reevaluationScheduled.
  ///
  /// In es, this message translates to:
  /// **'El paciente {name} tiene una reevaluación programada'**
  String reevaluationScheduled(String name);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
