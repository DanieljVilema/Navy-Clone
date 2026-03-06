import 'dart:convert';
import 'package:flutter/services.dart';

/// Automatically discovers and loads all PDFs from `assets/pdfs/`.
///
/// To add new knowledge for the chatbot, simply drop a PDF into `assets/pdfs/`
/// and rebuild the app. No config changes needed.
class PdfLoaderService {
  /// Returns asset paths for all PDFs found in `assets/pdfs/`.
  static Future<List<String>> discoverPdfAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest.listAssets()
          .where((key) =>
              key.startsWith('assets/pdfs/') &&
              key.toLowerCase().endsWith('.pdf'))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads all PDFs from `assets/pdfs/` and returns them as a list of
  /// (filename, bytes) pairs.
  static Future<List<PdfAsset>> loadAllPdfs() async {
    final paths = await discoverPdfAssets();
    final results = <PdfAsset>[];
    for (final path in paths) {
      try {
        final byteData = await rootBundle.load(path);
        final name = path.split('/').last.replaceAll('.pdf', '');
        results.add(PdfAsset(
          name: name,
          path: path,
          bytes: byteData.buffer.asUint8List(),
        ));
      } catch (_) {
        // Skip PDFs that fail to load
      }
    }
    return results;
  }
}

class PdfAsset {
  final String name;
  final String path;
  final Uint8List bytes;

  const PdfAsset({
    required this.name,
    required this.path,
    required this.bytes,
  });
}
