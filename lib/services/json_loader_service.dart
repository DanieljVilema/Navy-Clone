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
      final json = jsonDecode(data);
      return (json['baremos'] as List)
          .map((e) => BaremoEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

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
