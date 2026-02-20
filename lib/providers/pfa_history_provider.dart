import 'package:flutter/foundation.dart';
import '../models/pfa_result.dart';
import '../services/database_service.dart';

class PfaHistoryProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<PfaResult> _history = [];

  PfaHistoryProvider(this._db);

  List<PfaResult> get history => _history;
  PfaResult? get latestResult => _history.isNotEmpty ? _history.first : null;
  bool get hasHistory => _history.isNotEmpty;

  Future<void> loadHistory(int userId) async {
    _history = await _db.getPfaHistory(userId);
    if (_history.isEmpty) {
      // Load all results if no user-specific ones found
      _history = await _db.getAllPfaResults();
    }
    notifyListeners();
  }

  Future<void> addResult(PfaResult r) async {
    await _db.insertPfaResult(r);
    _history.insert(0, r);
    notifyListeners();
  }
}
