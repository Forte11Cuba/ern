# IRN - Índice de Riesgo Neurocognitivo

Aplicación clínica para Android que evalúa el riesgo de **Trastorno Neurocognitivo Leve debido a la Enfermedad de Alzheimer**. Calcula un score (0–59) a partir de 9 factores de riesgo y clasifica al paciente en **Bajo riesgo** o **Alto riesgo** según un punto de corte de 33.

## Base científica

Escala desarrollada por el **Dr. Julio Antonio Esquivel Tamayo** y **Arquímedes Montoya Pedrón**.

### Artículos publicados

1. Esquivel Tamayo JA, Montoya Pedrón A. *Predictive model of mild neurocognitive disorder due to Alzheimer's disease in Cuban adults.* Revista Mexicana de Neurociencias. 2025; 26(5). DOI: [10.24875/RMN.25000011](https://doi.org/10.24875/RMN.25000011)
2. Esquivel Tamayo JA, Montoya Pedrón A. *Validación interna de una escala predictiva de trastorno neurocognitivo leve debido a la enfermedad de Alzheimer.* Archivos de Neurociencias. 2026. DOI: [10.24875/ANC.25000057](https://doi.org/10.24875/ANC.25000057)

### Fórmula

| Factor | Peso |
|--------|------|
| Bajo nivel de competencias | 11 |
| Hipertensión arterial | 10 |
| COVID-19 | 8 |
| Bajo nivel de escolaridad | 7 |
| Obesidad | 7 |
| Diabetes mellitus | 5 |
| Pérdida de peso | 4 |
| Inactividad física | 4 |
| Tabaquismo | 3 |
| **Total máximo** | **59** |

**Punto de corte:** Score ≥ 33 → Alto riesgo · Score < 33 → Bajo riesgo

### Métricas de validación

| Métrica | Valor |
|---------|-------|
| Sensibilidad | 88.0 |
| Especificidad | 95.5 |
| AUC-ROC | 0.918 (IC: 0.877–0.958) |
| Índice de Youden | 0.835 |

## Funcionalidades

- **Evaluación en tiempo real** — Score se actualiza al marcar cada factor
- **Gestión de pacientes** — Registro, búsqueda, archivado (sin eliminación por integridad clínica)
- **Historial y versionado** — Cada edición conserva la versión anterior automáticamente
- **Reportes PDF** — Individuales por evaluación y agregados con estadísticas
- **Exportación CSV** — Con filtros para uso en investigación
- **Analíticas** — Distribución de scores, factores frecuentes, tendencias, correlaciones
- **Recordatorios** — Reevaluación automática (3 meses alto riesgo, 12 meses bajo riesgo)
- **Recomendaciones clínicas** — Generales y específicas por cada factor activo
- **Offline-first** — Base de datos local cifrada (SQLCipher), sin backend
- **Bilingüe** — Español e inglés
- **Accesibilidad** — Temas claro/oscuro/alto contraste, fuente ajustable

## Stack técnico

| | |
|---|---|
| Framework | Flutter 3.27 / Dart 3.6 |
| Arquitectura | Clean Architecture |
| Estado | Riverpod |
| Base de datos | SQLite cifrada (SQLCipher) |
| Gráficos | fl_chart |
| PDF | pdf + printing |
| Notificaciones | flutter_local_notifications |

## Compilar

```bash
flutter pub get
flutter gen-l10n
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Créditos

**Autor de la escala:** Dr. Julio Antonio Esquivel Tamayo

**Desarrollo:** [Javier Forte](https://github.com/Forte11Cuba)
