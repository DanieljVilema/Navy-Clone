import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

/// Shared utility to open PDF files from asset paths.
/// Used by both the regulations screen and the chatbot.
class PdfOpener {
  static Future<void> open(String assetPath, BuildContext context) async {
    try {
      if (kIsWeb) {
        final Uri url = Uri.parse(Uri.encodeFull(assetPath));
        if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
          throw Exception('No se puede abrir el PDF en la web');
        }
        return;
      }

      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final safeName = 'navy_reg_${assetPath.hashCode.abs()}.pdf';
      final file = File('${tempDir.path}/$safeName');
      await file.writeAsBytes(bytes, flush: true);

      try {
        final result =
            await OpenFile.open(file.path, type: 'application/pdf');
        if (result.type != ResultType.done) {
          await Share.shareXFiles(
              [XFile(file.path)], text: 'Abrir documento');
        }
      } catch (_) {
        await Share.shareXFiles(
            [XFile(file.path)], text: 'Abrir documento');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir PDF: $e'),
            duration: const Duration(seconds: 5),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}
