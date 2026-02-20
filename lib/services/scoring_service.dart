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
    // Try to find matching baremo
    final baremo = _findBaremo(genero, grupoEdad);

    double pushUpScore;
    double curlUpScore;
    double cardioScore;

    if (baremo != null && baremo.flexiones.isNotEmpty) {
      pushUpScore = _scoreFromBaremo(baremo.flexiones, flexiones.toDouble());
      curlUpScore =
          _scoreFromBaremo(baremo.abdominales, abdominales.toDouble());
      final totalCardioSec = cardioMinutos * 60 + cardioSegundos;
      final cardioThresholds = baremo.cardio.forType(tipoCardio);
      cardioScore = cardioThresholds.isNotEmpty
          ? _scoreFromBaremo(cardioThresholds, totalCardioSec.toDouble())
          : _fallbackCardioScore(totalCardioSec);
    } else {
      // Fallback: hardcoded formulas (current behavior)
      pushUpScore = (flexiones / 50 * 20).clamp(0, 20).toDouble();
      curlUpScore = (abdominales / 60 * 20).clamp(0, 20).toDouble();
      final totalCardioSec = cardioMinutos * 60 + cardioSegundos;
      cardioScore = _fallbackCardioScore(totalCardioSec);
    }

    final totalScore = pushUpScore + curlUpScore + cardioScore;
    final nivel = AppStrings.levelForScore(totalScore);

    // BCA calculations
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
      cardioSegundos: cardioMinutos * 60 + cardioSegundos,
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

  BaremoEntry? _findBaremo(String genero, String grupoEdad) {
    final generoCode = genero == 'Masculino' ? 'M' : 'F';
    for (final b in _baremos) {
      if ((b.genero == generoCode || b.genero == genero) &&
          (b.grupoEdad == grupoEdad)) {
        return b;
      }
    }
    return null;
  }

  double _scoreFromBaremo(List<BaremoThreshold> thresholds, double value) {
    // Thresholds are sorted desc by min: first match wins
    for (final t in thresholds) {
      if (value >= t.min) {
        return t.nota;
      }
    }
    return 0;
  }

  double _fallbackCardioScore(int totalSeconds) {
    if (totalSeconds <= 0) return 0;
    return ((900 - totalSeconds) / 900 * 60).clamp(0, 60).toDouble();
  }
}
