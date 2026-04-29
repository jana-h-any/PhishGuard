import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_model.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'phishguard.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scan_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email_id TEXT NOT NULL,
            sender TEXT NOT NULL,
            sender_email TEXT NOT NULL,
            subject TEXT NOT NULL,
            label TEXT NOT NULL,
            confidence REAL NOT NULL,
            risk_level TEXT NOT NULL,
            reasons TEXT NOT NULL,
            scanned_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertScanResult(HistoryModel history) async {
    final db = await database;
    return await db.insert('scan_history', history.toDb());
  }

  Future<List<HistoryModel>> getAllHistory() async {
    final db = await database;
    final maps = await db.query('scan_history', orderBy: 'scanned_at DESC');
    return maps.map((map) => HistoryModel.fromDb(map)).toList();
  }

  Future<List<HistoryModel>> getHistoryByLabel(String label) async {
    final db = await database;
    final maps = await db.query(
      'scan_history',
      where: 'label = ?',
      whereArgs: [label],
      orderBy: 'scanned_at DESC',
    );
    return maps.map((map) => HistoryModel.fromDb(map)).toList();
  }

  Future<Map<String, int>> getWeeklyStats() async {
    final db = await database;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    final total = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scan_history WHERE scanned_at >= ?',
      [weekAgo.toIso8601String()],
    );
    final phishing = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scan_history WHERE label = ? AND scanned_at >= ?',
      ['phishing', weekAgo.toIso8601String()],
    );
    final safe = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scan_history WHERE label = ? AND scanned_at >= ?',
      ['safe', weekAgo.toIso8601String()],
    );

    return {
      'total': (total.first['count'] as int?) ?? 0,
      'phishing': (phishing.first['count'] as int?) ?? 0,
      'safe': (safe.first['count'] as int?) ?? 0,
    };
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('scan_history');
  }
}
