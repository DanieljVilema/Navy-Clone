import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/baremo_entry.dart';
import '../models/nutrition_item.dart';
import '../models/video_item.dart';
import '../models/regulation_item.dart';
import '../models/training_category.dart';

class JsonLoaderService {
  static Future<List<BaremoEntry>> loadBaremos() async {
    try {
      final data = await rootBundle.loadString('assets/baremos.json');
      final json = jsonDecode(data) as Map<String, dynamic>;
      final entries = <BaremoEntry>[];

      // Map from baremos.json "edades" strings to app grupoEdad strings
      const ageMap = <String, List<String>>{
        '0 a 24 años':   ['17-19', '20-24'],
        '25 a 27 años':  ['25-29'],
        '28 a 30 años':  [],
        '31 a 33 años':  ['30-34'],
        '34 a 36 años':  [],
        '37 a 39 años':  ['35-39'],
        '40 a 42 años':  ['40-44'],
        '43 a 45 años':  [],
        '46 a 48 años':  ['45-49'],
        '49 a 51 años':  ['50-54'],
        '52 a 56 años':  ['55-59'],
        '57 años y más': ['60-64', '65+'],
      };

      for (final tablaEntry in json.entries) {
        final tabla = tablaEntry.value;
        if (tabla is! Map<String, dynamic>) continue;
        final edades = tabla['edades'] as String? ?? '';
        final grupoEdadList = ageMap[edades];
        if (grupoEdadList == null || grupoEdadList.isEmpty) continue;

        for (final generoKey in ['hombres', 'mujeres']) {
          final genData = tabla[generoKey] as Map<String, dynamic>?;
          if (genData == null) continue;
          final generoCode = generoKey == 'hombres' ? 'M' : 'F';

          final flexMeta =
              (genData['flexiones']?['meta'] as num?)?.toDouble();
          final abdMeta =
              (genData['abdominales']?['meta'] as num?)?.toDouble();
          final troteMeta =
              (genData['trote_segundos']?['meta'] as num?)?.toDouble();
          final natMeta =
              (genData['natacion_segundos']?['meta'] as num?)?.toDouble();

          for (final grupoEdad in grupoEdadList) {
            entries.add(BaremoEntry(
              grupoEdad: grupoEdad,
              genero: generoCode,
              flexiones: flexMeta != null ? _repsThresholds(flexMeta) : [],
              abdominales: abdMeta != null ? _repsThresholds(abdMeta) : [],
              cardio: CardioBaremo(
                trote2400m:
                    troteMeta != null ? _cardioThresholds(troteMeta) : [],
                natacion450m:
                    natMeta != null ? _cardioThresholds(natMeta) : [],
              ),
            ));
          }
        }
      }
      return entries;
    } catch (e) {
      return [];
    }
  }

  /// Generates 5 tiered thresholds for reps-based events.
  /// [meta] = reps required for full score per Navy baremos.
  static List<BaremoThreshold> _repsThresholds(double meta) => [
        BaremoThreshold(
            min: (meta * 1.2).floor(), nota: 100, nivel: 'Sobresaliente'),
        BaremoThreshold(min: meta.floor(), nota: 90, nivel: 'Bueno'),
        BaremoThreshold(
            min: (meta * 0.8).floor(), nota: 75, nivel: 'Satisfactorio'),
        BaremoThreshold(
            min: (meta * 0.6).floor(), nota: 60, nivel: 'Regular'),
        BaremoThreshold(
            min: (meta * 0.4).floor(), nota: 45, nivel: 'Deficiente'),
      ];

  /// Generates 5 tiered thresholds for cardio events (seconds, lower = better).
  /// [metaSec] = seconds for full score per Navy baremos.
  static List<BaremoThreshold> _cardioThresholds(double metaSec) => [
        BaremoThreshold(
            min: 0,
            nota: 100,
            nivel: 'Sobresaliente',
            maxSeg: (metaSec * 0.90).ceil()),
        BaremoThreshold(
            min: 0, nota: 90, nivel: 'Bueno', maxSeg: metaSec.ceil()),
        BaremoThreshold(
            min: 0,
            nota: 75,
            nivel: 'Satisfactorio',
            maxSeg: (metaSec * 1.10).ceil()),
        BaremoThreshold(
            min: 0,
            nota: 60,
            nivel: 'Regular',
            maxSeg: (metaSec * 1.20).ceil()),
        BaremoThreshold(
            min: 0,
            nota: 45,
            nivel: 'Deficiente',
            maxSeg: (metaSec * 1.30).ceil()),
      ];

  static Future<List<NutritionItem>> loadNutrition() async {
    try {
      final data = await rootBundle.loadString('assets/nutrition_guide.json');
      final json = jsonDecode(data);
      return (json['plan_nutricional'] as List)
          .map((e) => NutritionItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<VideoItem>> loadVideos() async {
    try {
      final data = await rootBundle.loadString('assets/videos_config.json');
      final json = jsonDecode(data);
      return (json['videos'] as List)
          .map((e) => VideoItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<RegulationItem>> loadRegulations() async {
    try {
      final data =
          await rootBundle.loadString('assets/regulations_config.json');
      final json = jsonDecode(data);
      final regulaciones = (json['regulaciones'] as List?)
              ?.map((e) => RegulationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      final recursos = (json['recursos_adicionales'] as List?)
              ?.map((e) => RegulationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return [...regulaciones, ...recursos];
    } catch (e) {
      return [];
    }
  }

  static Future<List<TrainingCategory>> loadTraining() async {
    try {
      final data = await rootBundle.loadString('assets/training_config.json');
      final json = jsonDecode(data);
      return (json['categorias'] as List)
          .map((e) => TrainingCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> loadRegulationsContent() async {
    try {
      final data =
          await rootBundle.loadString('assets/regulations_text.json');
      final json = jsonDecode(data);
      final descriptions = <String, String>{};
      final pdfPaths = <String>[];
      for (final item in json['regulations_content'] as List) {
        final id = item['id'] as String? ?? '';
        final titulo = item['titulo'] as String? ?? '';
        final descripcion = item['descripcion'] as String? ?? '';
        final pdfAsset = item['pdfAsset'] as String? ?? '';
        final sendToGemini = item['sendToGemini'] as bool? ?? false;
        if (id.isNotEmpty) {
          descriptions[id] = '$titulo: $descripcion';
        }
        if (sendToGemini && pdfAsset.isNotEmpty) {
          pdfPaths.add(pdfAsset);
        }
      }
      return {'descriptions': descriptions, 'pdfPaths': pdfPaths};
    } catch (e) {
      return {'descriptions': <String, String>{}, 'pdfPaths': <String>[]};
    }
  }
}
