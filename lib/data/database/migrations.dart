import 'package:sqflite_sqlcipher/sqflite.dart';

class Migrations {
  static Future<void> createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_code TEXT UNIQUE NOT NULL,
        name TEXT,
        birth_date TEXT,
        age INTEGER NOT NULL,
        sex TEXT,
        medical_record TEXT,
        notes TEXT,
        is_archived INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cognitive_assessments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        hypertension INTEGER NOT NULL,
        low_competence INTEGER NOT NULL,
        low_education INTEGER NOT NULL,
        covid INTEGER NOT NULL,
        obesity INTEGER NOT NULL,
        diabetes INTEGER NOT NULL,
        weight_loss INTEGER NOT NULL,
        inactivity INTEGER NOT NULL,
        smoking INTEGER NOT NULL,
        total_score INTEGER NOT NULL,
        risk_category TEXT NOT NULL,
        clinical_notes TEXT,
        version INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE assessment_versions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        assessment_id INTEGER NOT NULL,
        version_number INTEGER NOT NULL,
        hypertension INTEGER NOT NULL,
        low_competence INTEGER NOT NULL,
        low_education INTEGER NOT NULL,
        covid INTEGER NOT NULL,
        obesity INTEGER NOT NULL,
        diabetes INTEGER NOT NULL,
        weight_loss INTEGER NOT NULL,
        inactivity INTEGER NOT NULL,
        smoking INTEGER NOT NULL,
        total_score INTEGER NOT NULL,
        risk_category TEXT NOT NULL,
        clinical_notes TEXT,
        changed_at TEXT NOT NULL,
        FOREIGN KEY (assessment_id) REFERENCES cognitive_assessments(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reevaluation_reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        assessment_id INTEGER NOT NULL,
        scheduled_date TEXT NOT NULL,
        interval_months INTEGER NOT NULL,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (patient_id) REFERENCES patients(id),
        FOREIGN KEY (assessment_id) REFERENCES cognitive_assessments(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE schema_versions (
        version INTEGER PRIMARY KEY,
        applied_at TEXT NOT NULL
      )
    ''');

    await db.insert('schema_versions', {
      'version': 1,
      'applied_at': DateTime.now().toIso8601String(),
    });

    // Indexes for common queries
    await db.execute(
        'CREATE INDEX idx_assessments_patient ON cognitive_assessments(patient_id)');
    await db.execute(
        'CREATE INDEX idx_versions_assessment ON assessment_versions(assessment_id)');
    await db.execute(
        'CREATE INDEX idx_reminders_patient ON reevaluation_reminders(patient_id)');
    await db.execute(
        'CREATE INDEX idx_reminders_scheduled ON reevaluation_reminders(scheduled_date)');
  }

  static Future<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    // Future migrations go here:
    // if (oldVersion < 2) { await _migrateV1ToV2(db); }
  }
}
