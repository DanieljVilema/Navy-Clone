import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class ExerciseWeeklyBarChart extends StatelessWidget {
  final Map<int, double> weeklyTotals;
  final String metricLabel;

  const ExerciseWeeklyBarChart({
    super.key,
    required this.weeklyTotals,
    required this.metricLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxVal =
        weeklyTotals.values.reduce((a, b) => a > b ? a : b);
    final roundedMax = ((maxVal / 10).ceil() * 10).toDouble() + 10;

    return Container(
      height: 180,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8, left: 4),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: roundedMax,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(0)} $metricLabel',
                  GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Sem ${value.toInt()}',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.darkTextTertiary),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: roundedMax / 4,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.darkTextTertiary),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: roundedMax / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.darkBorder,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(5, (i) {
            final week = i + 1;
            final value = weeklyTotals[week] ?? 0;
            return BarChartGroupData(
              x: week,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: AppColors.primary,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: roundedMax,
                    color: AppColors.darkCardSec,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
