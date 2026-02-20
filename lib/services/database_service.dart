import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';
import '../models/pfa_result.dart';
import '../models/chat_message.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'navy_pfa.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL DEFAULT 'Usuario',
        genero TEXT NOT NULL DEFAULT 'Masculino',
        grupo_edad TEXT NOT NULL DEFAULT '20-24',
        altura_pulg REAL,
        cintura_pulg REAL,
        peso_lb REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pfa_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        tipo_cardio TEXT NOT NULL,
        flexiones_raw INTEGER,
        abdominales_raw INTEGER,
        cardio_segundos INTEGER,
        nota_flexiones REAL NOT NULL,
        nota_abdominales REAL NOT NULL,
        nota_cardio REAL NOT NULL,
        nota_total REAL NOT NULL,
        nivel TEXT NOT NULL,
        cintura_ratio REAL,
        imc REAL,
        estado_bca TEXT,
        FOREIGN KEY (user_id) REFERENCES user_profiles(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT NOT NULL,
        text TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // ── USER PROFILE ──

  Future<int> insertUserProfile(UserProfile p) async {
    final db = await database;
    return db.insert('user_profiles', p.toMap());
  }

  Future<UserProfile?> getActiveProfile() async {
    final db = await database;
    final maps = await db.query('user_profiles', orderBy: 'id DESC', limit: 1);
    if (maps.isEmpty) return null;
    return UserProfile.fromMap(maps.first);
  }

  Future<int> updateUserProfile(UserProfile p) async {
    final db = await database;
    return db.update(
      'user_profiles',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  // ── PFA RESULTS ──

  Future<int> insertPfaResult(PfaResult r) async {
    final db = await database;
    return db.insert('pfa_results', r.toMap());
  }

  Future<List<PfaResult>> getPfaHistory(int userId) async {
    final db = await database;
    final maps = await db.query(
      'pfa_results',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'fecha DESC',
    );
    return maps.map((m) => PfaResult.fromMap(m)).toList();
  }

  Future<List<PfaResult>> getAllPfaResults() async {
    final db = await database;
    final maps = await db.query('pfa_results', orderBy: 'fecha DESC');
    return maps.map((m) => PfaResult.fromMap(m)).toList();
  }

  // ── CHAT MESSAGES ──

  Future<int> insertChatMessage(ChatMessageModel m) async {
    final db = await database;
    return db.insert('chat_messages', m.toMap());
  }

  Future<List<ChatMessageModel>> getChatHistory({int limit = 50}) async {
    final db = await database;
    final maps = await db.query(
      'chat_messages',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map((m) => ChatMessageModel.fromMap(m)).toList();
  }

  Future<void> clearChatHistory() async {
    final db = await database;
    await db.delete('chat_messages');
  }
}
