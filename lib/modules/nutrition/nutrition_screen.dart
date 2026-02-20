import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import '../../core/constants.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ContentProvider>().nutrition;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.darkCardSec,
                      borderRadius: BorderRadius.circular(Radii.full),
                    ),
                    child: const Icon(Icons.restaurant_outlined, size: 36, color: AppColors.darkTextTertiary),
                  ),
                  const SizedBox(height: Spacing.m),
                  Text('Sin datos de nutrición', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                  const SizedBox(height: Spacing.s),
                  SizedBox(
                    width: 280,
                    child: Text('Los planes nutricionales se cargarán aquí.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkTextSecondary)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(Spacing.m),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: Spacing.m),
                  padding: const EdgeInsets.all(Spacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(Radii.m),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(Radii.m),
                        ),
                        child: const Icon(Icons.restaurant, size: 22, color: AppColors.success),
                      ),
                      const SizedBox(width: Spacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.titulo, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                            const SizedBox(height: Spacing.xs),
                            Text(item.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkTextSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.darkTextTertiary),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
