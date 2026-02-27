import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _opening = false;

  Future<void> _openPdf(String assetPath) async {
    if (_opening) return;
    setState(() => _opening = true);
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
        final result = await OpenFile.open(file.path, type: 'application/pdf');
        if (result.type != ResultType.done) {
          await Share.shareXFiles([XFile(file.path)], text: 'Abrir reglamento');
        }
      } catch (_) {
        await Share.shareXFiles([XFile(file.path)], text: 'Abrir reglamento');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al preparar PDF: $e'),
            duration: const Duration(seconds: 5),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── HEADER DESCRIPTION ──
          Container(
            padding: const EdgeInsets.all(Spacing.m),
            color: AppColors.darkCard,
            child: Text(
              'Todos los recursos de políticas del Programa de Preparación Física de la Armada, incluyendo lo siguiente:',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.darkBorder),

          // ── POLICY RESOURCE ITEMS ──
          ...context.watch<ContentProvider>().regulations.where((r) => !r.isExternal).map(
                (r) => _PolicyItem(
                  title: r.titulo,
                  subtitle: r.subtitulo,
                  onTap: (r.pdfAsset?.isNotEmpty ?? false)
                      ? () => _openPdf(r.pdfAsset!)
                      : null,
                ),
              ),

          const SizedBox(height: 20),

          // ── ADDITIONAL RESOURCES SECTION ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 12),
            color: AppColors.darkCardSec,
            child: Text(
              'Recursos Adicionales',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.darkBorder),

          ...context.watch<ContentProvider>().regulations.where((r) => r.isExternal).map(
                (r) => _PolicyItem(
                  title: r.titulo,
                  subtitle: r.subtitulo,
                  trailing: Icons.open_in_new,
                  onTap: null,
                ),
              ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? trailing;
  final VoidCallback? onTap;

  const _PolicyItem({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.darkCard,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.darkTextTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    trailing ?? Icons.picture_as_pdf_outlined,
                    size: 20,
                    color: onTap != null
                        ? AppColors.primary
                        : AppColors.darkTextTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.darkBorder,
          indent: Spacing.m,
        ),
      ],
    );
  }
}
