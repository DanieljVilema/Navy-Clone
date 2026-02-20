import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import '../../core/constants.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

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
          Divider(height: 1, color: Colors.grey.shade200),

          // ── POLICY RESOURCE ITEMS ──
          ...context.watch<ContentProvider>().regulations.where((r) => !r.isExternal).map(
                (r) => _PolicyItem(
                  title: r.titulo,
                  subtitle: r.subtitulo,
                  onTap: () {},
                ),
              ).toList(),

          const SizedBox(height: 20),

          // ── ADDITIONAL RESOURCES SECTION ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey.shade50,
            child: Text(
              'Recursos Adicionales',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          ...context.watch<ContentProvider>().regulations.where((r) => r.isExternal).map(
                (r) => _PolicyItem(
                  title: r.titulo,
                  subtitle: r.subtitulo,
                  trailing: Icons.open_in_new,
                  onTap: () {},
                ),
              ).toList(),

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
  final VoidCallback onTap;

  const _PolicyItem({
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    trailing ?? Icons.chevron_right,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade200,
          indent: 20,
        ),
      ],
    );
  }
}
