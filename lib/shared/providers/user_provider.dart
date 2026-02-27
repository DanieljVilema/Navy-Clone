import 'package:flutter/foundation.dart';
import 'package:navy_pfa_armada_ecuador/shared/models/user_profile.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseService _db;
  UserProfile? _profile;

  UserProvider(this._db);

  UserProfile? get profile => _profile;
  bool get hasProfile => _profile != null;
  int get userId => _profile?.id ?? 1;

  Future<void> loadProfile() async {
    _profile = await _db.getActiveProfile();
    if (_profile == null) {
      // Create default profile
      final defaultProfile = UserProfile();
      final id = await _db.insertUserProfile(defaultProfile);
      _profile = defaultProfile.copyWith(id: id);
    }
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile p) async {
    if (p.id != null) {
      await _db.updateUserProfile(p);
      _profile = p;
    } else {
      final id = await _db.insertUserProfile(p);
      _profile = p.copyWith(id: id);
    }
    notifyListeners();
  }

  Future<void> updateField({
    String? nombre,
    String? genero,
    String? grupoEdad,
    double? alturaPulg,
    double? cinturaPulg,
    double? pesoLb,
  }) async {
    if (_profile == null) return;
    final updated = _profile!.copyWith(
      nombre: nombre,
      genero: genero,
      grupoEdad: grupoEdad,
      alturaPulg: alturaPulg,
      cinturaPulg: cinturaPulg,
      pesoLb: pesoLb,
    );
    await saveProfile(updated);
  }
}
