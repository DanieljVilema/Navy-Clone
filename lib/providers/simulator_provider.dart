import 'package:flutter/foundation.dart';
import '../models/pfa_result.dart';
import '../services/scoring_service.dart';

class SimulatorProvider extends ChangeNotifier {
  String genero = 'Masculino';
  String grupoEdad = '17-19';
  String altitud = 'Bajo 5000 pies';
  String tipoCardio = 'Trote 2.4km';

  PfaResult? lastResult;

  void updateGenero(String v) {
    genero = v;
    notifyListeners();
  }

  void updateGrupoEdad(String v) {
    grupoEdad = v;
    notifyListeners();
  }

  void updateAltitud(String v) {
    altitud = v;
    notifyListeners();
  }

  void updateTipoCardio(String v) {
    tipoCardio = v;
    notifyListeners();
  }

  void calculate({
    required ScoringService scorer,
    required int userId,
    required int flexiones,
    required int abdominales,
    required int cardioMinutos,
    required int cardioSegundos,
    double? alturaPulg,
    double? cinturaPulg,
    double? pesoLb,
  }) {
    lastResult = scorer.calculate(
      userId: userId,
      genero: genero,
      grupoEdad: grupoEdad,
      flexiones: flexiones,
      abdominales: abdominales,
      cardioMinutos: cardioMinutos,
      cardioSegundos: cardioSegundos,
      tipoCardio: tipoCardio,
      alturaPulg: alturaPulg,
      cinturaPulg: cinturaPulg,
      pesoLb: pesoLb,
    );
    notifyListeners();
  }

  void reset() {
    genero = 'Masculino';
    grupoEdad = '17-19';
    altitud = 'Bajo 5000 pies';
    tipoCardio = 'Trote 2.4km';
    lastResult = null;
    notifyListeners();
  }
}
