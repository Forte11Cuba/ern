import 'dart:io';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show sqfliteFfiInit, databaseFactoryFfi;
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';
import 'migrations.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  /// For testing: allows injecting a database instance.
  factory DatabaseHelper.withDatabase(Database db) {
    final helper = DatabaseHelper._();
    _database = db;
    return helper;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static bool get _isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  Future<Database> _initDatabase() async {
    if (_isDesktop) {
      return _initDesktop();
    }
    return _initMobile();
  }

  /// Desktop: use FFI factory directly (bypasses platform channel)
  Future<Database> _initDesktop() async {
    sqfliteFfiInit();
    final factory = databaseFactoryFfi;
    final dbPath = await factory.getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  /// Mobile: use sqflite_sqlcipher with encryption
  Future<Database> _initMobile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      password: 'neurocognitive_secure_key',
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await Migrations.createAllTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await Migrations.migrate(db, oldVersion, newVersion);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
