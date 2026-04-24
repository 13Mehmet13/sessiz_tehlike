import 'package:path/path.dart';
import 'package:sessiz_tehlike/models/alert_record.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'sessiz_tehlike.db');
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE alerts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            soundType TEXT,
            decibel REAL,
            createdAt TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insertAlert(AlertRecord alert) async {
    final db = await database;
    return db.insert('alerts', alert.toMap());
  }

  Future<List<AlertRecord>> getAlerts() async {
    final db = await database;
    final rows = await db.query('alerts', orderBy: 'createdAt DESC');
    return rows.map(AlertRecord.fromMap).toList();
  }

  Future<int> clearAlerts() async {
    final db = await database;
    return db.delete('alerts');
  }
}
