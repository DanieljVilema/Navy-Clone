import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import '../../core/constants.dart';

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
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      // Use a hash-based name to avoid issues with long/special-character filenames
      final safeName = 'navy_reg_${assetPath.hashCode.abs()}.pdf';
      final file = File('${tempDir.path}/$safeName');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir PDF: $e'),
            duration: const Duration(seconds: 5),
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
