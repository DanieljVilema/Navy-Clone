import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

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
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.darkBg,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(Spacing.l),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40, height: 4,
                                  margin: const EdgeInsets.only(bottom: Spacing.l),
                                  decoration: BoxDecoration(color: AppColors.darkCardSec, borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                              if (item.categoria != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(Radii.s)),
                                  child: Text(item.categoria!.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                                ),
                              const SizedBox(height: Spacing.m),
                              Text(item.titulo, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary)),
                              const SizedBox(height: Spacing.s),
                              Text(item.descripcion, style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkTextSecondary, height: 1.5)),
                              if (item.caloriasAprox != null && item.caloriasAprox != 'N/A') ...[
                                const SizedBox(height: Spacing.m),
                                Row(
                                  children: [
                                    const Icon(Icons.local_fire_department, size: 18, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text('Calorías: ${item.caloriasAprox}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                                  ],
                                ),
                              ],
                              if (item.alimentos.isNotEmpty) ...[
                                const SizedBox(height: Spacing.l),
                                Text('Alimentos recomendados:', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                                const SizedBox(height: Spacing.s),
                                ...item.alimentos.map((alimento) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(alimento, style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkTextSecondary))),
                                    ],
                                  ),
                                )),
                              ],
                              const SizedBox(height: Spacing.xl),
                            ],
                          ),
                        ),
                      );
                    },
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
                              if (item.categoria != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(item.categoria!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                                ),
                              Text(item.titulo, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                              const SizedBox(height: Spacing.xs),
                              Text(item.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkTextSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: AppColors.darkTextTertiary),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
