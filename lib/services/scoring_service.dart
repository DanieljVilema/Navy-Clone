import '../models/baremo_entry.dart';
import '../models/pfa_result.dart';
import '../core/constants.dart';

class ScoringService {
  final List<BaremoEntry> _baremos;

  ScoringService(this._baremos);

  PfaResult calculate({
    required int userId,
    required String genero,
    required String grupoEdad,
    required int flexiones,
    required int abdominales,
    required int cardioMinutos,
    required int cardioSegundos,
    required String tipoCardio,
    double? alturaPulg,
    double? cinturaPulg,
    double? pesoLb,
  }) {
    final baremo = _findBaremo(genero, grupoEdad);
    final totalCardioSec = cardioMinutos * 60 + cardioSegundos;

    double pushUpScore;
    double curlUpScore;
    double cardioScore;

    if (baremo != null && baremo.flexiones.isNotEmpty) {
      pushUpScore = _scoreReps(baremo.flexiones, flexiones);
      curlUpScore = baremo.abdominales.isNotEmpty
          ? _scoreReps(baremo.abdominales, abdominales)
          : _fallbackRepScore(abdominales, 60);
      final cardioThresholds = baremo.cardio.forType(tipoCardio);
      cardioScore = cardioThresholds.isNotEmpty
          ? _scoreCardio(cardioThresholds, totalCardioSec)
          : _fallbackCardioScore(totalCardioSec);
    } else {
      pushUpScore = _fallbackRepScore(flexiones, 50);
      curlUpScore = _fallbackRepScore(abdominales, 60);
      cardioScore = _fallbackCardioScore(totalCardioSec);
    }

    // Total = average of three component scores (each 0-100)
    final totalScore = (pushUpScore + curlUpScore + cardioScore) / 3.0;
    final nivel = AppStrings.levelForScore(totalScore);

    // BCA calculations (imperial inputs)
    double? cinturaRatio;
    String? estadoBca;
    double? imc;

    if (alturaPulg != null && alturaPulg > 0) {
      if (cinturaPulg != null && cinturaPulg > 0) {
        cinturaRatio = cinturaPulg / alturaPulg;
        estadoBca = cinturaRatio <= 0.5500 ? 'APROBADO' : 'FALLO';
      }
      if (pesoLb != null && pesoLb > 0) {
        imc = (pesoLb / (alturaPulg * alturaPulg)) * 703;
      }
    }

    return PfaResult(
      userId: userId,
      fecha: DateTime.now(),
      tipoCardio: tipoCardio,
      flexionesRaw: flexiones,
      abdominalesRaw: abdominales,
      cardioSegundos: totalCardioSec,
      notaFlexiones: double.parse(pushUpScore.toStringAsFixed(1)),
      notaAbdominales: double.parse(curlUpScore.toStringAsFixed(1)),
      notaCardio: double.parse(cardioScore.toStringAsFixed(1)),
      notaTotal: double.parse(totalScore.toStringAsFixed(1)),
      nivel: nivel,
      cinturaRatio: cinturaRatio,
      imc: imc != null ? double.parse(imc.toStringAsFixed(1)) : null,
      estadoBca: estadoBca,
    );
  }

  /// Public: score a reps-based exercise (flexiones, abdominales) from a log entry.
  double scoreReps(String clave, int reps, String genero, String grupoEdad) {
    if (reps <= 0) return 0;
    final baremo = _findBaremo(genero, grupoEdad);
    if (baremo == null) {
      final threshold = clave == 'abdominales' ? 60 : 50;
      return _fallbackRepScore(reps, threshold);
    }
    switch (clave) {
      case 'flexiones':
        return baremo.flexiones.isNotEmpty
            ? _scoreReps(baremo.flexiones, reps)
            : _fallbackRepScore(reps, 50);
      case 'abdominales':
        return baremo.abdominales.isNotEmpty
            ? _scoreReps(baremo.abdominales, reps)
            : _fallbackRepScore(reps, 60);
      default:
        return 0;
    }
  }

  /// Public: score a cardio exercise (trote) from a log entry (duration in seconds).
  double scoreCardio(String clave, int totalSec, String genero, String grupoEdad) {
    if (totalSec <= 0) return 0;
    final baremo = _findBaremo(genero, grupoEdad);
    if (baremo == null) return _fallbackCardioScore(totalSec);
    if (clave == 'trote') {
      final thresholds = baremo.cardio.forType('Trote 2.4km');
      return thresholds.isNotEmpty
          ? _scoreCardio(thresholds, totalSec)
          : _fallbackCardioScore(totalSec);
    }
    if (clave == 'natacion') {
      final thresholds = baremo.cardio.forType('Natación 450m');
      return thresholds.isNotEmpty
          ? _scoreCardio(thresholds, totalSec)
          : _fallbackCardioScore(totalSec);
    }
    return _fallbackCardioScore(totalSec);
  }

  BaremoEntry? _findBaremo(String genero, String grupoEdad) {
    final generoCode = genero == 'Masculino' ? 'M' : 'F';
    for (final b in _baremos) {
      if ((b.genero == generoCode || b.genero == genero) &&
          b.grupoEdad == grupoEdad) {
        return b;
      }
    }
    return null;
  }

  /// Score reps-based events: thresholds sorted desc by min, first match wins
  double _scoreReps(List<BaremoThreshold> thresholds, int reps) {
    for (final t in thresholds) {
      if (reps >= t.min) {
        return t.nota;
      }
    }
    return 0;
  }

  /// Score cardio by time: thresholds have maxSeg, lower time = better
  double _scoreCardio(List<BaremoThreshold> thresholds, int totalSec) {
    if (totalSec <= 0) return 0;
    // Thresholds sorted best→worst (highest nota first, lowest maxSeg first)
    for (final t in thresholds) {
      if (t.maxSeg != null && totalSec <= t.maxSeg!) {
        return t.nota;
      }
    }
    return 30; // worst tier
  }

  double _fallbackRepScore(int reps, int excellentThreshold) {
    if (reps <= 0) return 0;
    final ratio = reps / excellentThreshold;
    if (ratio >= 1.2) return 100;
    if (ratio >= 1.0) return 90;
    if (ratio >= 0.8) return 75;
    if (ratio >= 0.6) return 60;
    if (ratio >= 0.4) return 45;
    return 30;
  }

  double _fallbackCardioScore(int totalSeconds) {
    if (totalSeconds <= 0) return 0;
    if (totalSeconds <= 570) return 100.0;
    if (totalSeconds <= 636) return 90.0;
    if (totalSeconds <= 750) return 75.0;
    if (totalSeconds <= 870) return 60.0;
    if (totalSeconds <= 1020) return 45.0;
    return 30.0;
  }
}
