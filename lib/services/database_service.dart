import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';
import '../models/pfa_result.dart';
import '../models/chat_message.dart';
import '../models/exercise_type.dart';
import '../models/exercise_log.dart';

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
      version: 3,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Always ensure exercise tables + seed data exist, regardless of migration state.
        // Both calls are idempotent: IF NOT EXISTS + INSERT OR IGNORE.
        await _createExerciseTables(db);
        await _seedExerciseTypes(db);
      },
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

    // v2 tables
    await _createExerciseTables(db);
    await _seedExerciseTypes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createExerciseTables(db);
      await _seedExerciseTypes(db);
    }
    if (oldVersion < 3) {
      // Ensure exercise tables exist (handles DBs at v2 that missed the migration)
      await _createExerciseTables(db);
      await _seedExerciseTypes(db);
    }
  }

  Future<void> _createExerciseTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        clave TEXT NOT NULL UNIQUE,
        categoria TEXT NOT NULL,
        metrica_principal TEXT NOT NULL,
        icono TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        exercise_type_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        repeticiones INTEGER,
        duracion_segundos INTEGER,
        distancia_metros REAL,
        frecuencia_cardiaca INTEGER,
        notas TEXT,
        fuente TEXT NOT NULL DEFAULT 'manual',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_profiles(id),
        FOREIGN KEY (exercise_type_id) REFERENCES exercise_types(id)
      )
    ''');
  }

  Future<void> _seedExerciseTypes(Database db) async {
    final types = [
      {'nombre': 'Flexiones', 'clave': 'flexiones', 'categoria': 'fuerza_superior', 'metrica_principal': 'repeticiones', 'icono': 'fitness_center'},
      {'nombre': 'Abdominales', 'clave': 'abdominales', 'categoria': 'fuerza_core', 'metrica_principal': 'repeticiones', 'icono': 'accessibility_new'},
      {'nombre': 'Barras', 'clave': 'barras', 'categoria': 'fuerza_superior', 'metrica_principal': 'repeticiones', 'icono': 'iron'},
      {'nombre': 'Fondos en Paralela', 'clave': 'fondos', 'categoria': 'fuerza_superior', 'metrica_principal': 'repeticiones', 'icono': 'sports_gymnastics'},
      {'nombre': 'Trote', 'clave': 'trote', 'categoria': 'cardio', 'metrica_principal': 'distancia', 'icono': 'directions_run'},
      {'nombre': 'Natación', 'clave': 'natacion', 'categoria': 'cardio', 'metrica_principal': 'distancia', 'icono': 'pool'},
    ];
    for (final t in types) {
      await db.insert('exercise_types', t, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
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

  // ── EXERCISE TYPES ──

  Future<List<ExerciseType>> getExerciseTypes() async {
    try {
      final db = await database;
      var maps = await db.query('exercise_types', orderBy: 'id ASC');
      if (maps.isEmpty) {
        await _createExerciseTables(db);
        await _seedExerciseTypes(db);
        maps = await db.query('exercise_types', orderBy: 'id ASC');
      }
      return maps.map((m) => ExerciseType.fromMap(m)).toList();
    } catch (_) {
      return [];
    }
  }

  // ── EXERCISE LOGS ──

  Future<int> insertExerciseLog(ExerciseLog log) async {
    final db = await database;
    return db.insert('exercise_logs', log.toMap());
  }

  Future<List<ExerciseLog>> getExerciseLogs({
    required int userId,
    DateTime? from,
    DateTime? to,
    String? exerciseTypeClave,
  }) async {
    final db = await database;
    final types = await getExerciseTypes();
    final typeMap = {for (final t in types) t.id!: t};

    String where = 'el.user_id = ?';
    final args = <dynamic>[userId];

    if (from != null) {
      where += ' AND el.fecha >= ?';
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where += ' AND el.fecha <= ?';
      args.add(to.toIso8601String());
    }
    if (exerciseTypeClave != null) {
      final typeId = types
          .where((t) => t.clave == exerciseTypeClave)
          .map((t) => t.id)
          .firstOrNull;
      if (typeId != null) {
        where += ' AND el.exercise_type_id = ?';
        args.add(typeId);
      }
    }

    final maps = await db.rawQuery(
      'SELECT el.* FROM exercise_logs el WHERE $where ORDER BY el.fecha DESC, el.created_at DESC',
      args,
    );

    return maps
        .map((m) =>
            ExerciseLog.fromMap(m, exerciseType: typeMap[m['exercise_type_id']]))
        .toList();
  }

  Future<List<ExerciseLog>> getExerciseLogsByMonth(
      int userId, int year, int month) async {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 0, 23, 59, 59);
    return getExerciseLogs(userId: userId, from: from, to: to);
  }

  Future<int> deleteExerciseLog(int id) async {
    final db = await database;
    return db.delete('exercise_logs', where: 'id = ?', whereArgs: [id]);
  }
}
