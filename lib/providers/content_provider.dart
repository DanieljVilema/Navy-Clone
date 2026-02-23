import 'package:flutter/foundation.dart';
import '../models/video_item.dart';
import '../models/nutrition_item.dart';
import '../models/regulation_item.dart';
import '../models/training_category.dart';
import '../models/baremo_entry.dart';
import '../services/json_loader_service.dart';

class ContentProvider extends ChangeNotifier {
  List<VideoItem> _videos = [];
  List<NutritionItem> _nutrition = [];
  List<RegulationItem> _regulations = [];
  List<TrainingCategory> _training = [];
  List<BaremoEntry> _baremos = [];
  Map<String, String> _regulationsContent = {};
  bool _isLoaded = false;

  List<VideoItem> get videos => _videos;
  List<NutritionItem> get nutrition => _nutrition;
  List<RegulationItem> get regulations => _regulations;
  List<TrainingCategory> get training => _training;
  List<BaremoEntry> get baremos => _baremos;
  bool get isLoaded => _isLoaded;
  Map<String, String> get regulationsContent => _regulationsContent;

  List<VideoItem> videosByCategory(String cat) =>
      _videos.where((v) => v.categoria == cat).toList();

  /// Returns baremos data as a concise string for Gemini system instructions
  String get baremosContext {
    if (_baremos.isEmpty) return 'Datos de baremos pendientes de carga.';
    final buffer = StringBuffer();
    for (final b in _baremos) {
      buffer.writeln('Grupo: ${b.grupoEdad}, Género: ${b.genero}');
      if (b.flexiones.isNotEmpty) {
        buffer.write('  Flexiones: ');
        buffer.writeln(b.flexiones
            .map((t) => '${t.min}+ reps = ${t.nota} pts (${t.nivel})')
            .join(', '));
      }
      if (b.abdominales.isNotEmpty) {
        buffer.write('  Abdominales: ');
        buffer.writeln(b.abdominales
            .map((t) => '${t.min}+ reps = ${t.nota} pts (${t.nivel})')
            .join(', '));
      }
    }
    return buffer.toString();
  }

  /// Returns nutrition data as a concise string for Gemini system instructions
  String get nutritionContext {
    if (_nutrition.isEmpty) return 'Datos de nutrición pendientes de carga.';
    return _nutrition
        .map((n) => '${n.titulo}: ${n.descripcion}')
        .join('\n');
  }

  Future<void> loadAllContent() async {
    if (_isLoaded) return;
    _baremos = await JsonLoaderService.loadBaremos();
    _nutrition = await JsonLoaderService.loadNutrition();
    _videos = await JsonLoaderService.loadVideos();
    _regulations = await JsonLoaderService.loadRegulations();
    _training = await JsonLoaderService.loadTraining();
    _regulationsContent = await JsonLoaderService.loadRegulationsContent();
    _isLoaded = true;
    notifyListeners();
  }

  /// Returns regulations data as a concise string for Gemini system instructions
  String get regulationsContext {
    if (_regulationsContent.isEmpty) {
      return 'Datos de reglamentos pendientes de carga.';
    }
    return _regulationsContent.values.join('\n---\n');
  }
}
