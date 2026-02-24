import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';

class ExerciseProgressChart extends StatelessWidget {
  final List<FlSpot> spots;
  final String metricLabel;
  final int daysInMonth;

  const ExerciseProgressChart({
    super.key,
    required this.spots,
    required this.metricLabel,
    required this.daysInMonth,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'Sin datos para este ejercicio en el mes seleccionado.',
          style: GoogleFonts.inter(
            color: AppColors.darkTextSecondary,
            fontSize: 13,
          ),
        ),
      );
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final roundedMaxY = ((maxY / 10).ceil() * 10).toDouble() + 10;

    return Container(
      height: 220,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8, left: 4),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: roundedMaxY / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.darkBorder,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  final day = value.toInt();
                  if (day <= 0 || day > daysInMonth) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '$day',
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
                interval: roundedMaxY / 5,
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
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: daysInMonth.toDouble(),
          minY: 0,
          maxY: roundedMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    'Día ${spot.x.toInt()}\n${spot.y.toStringAsFixed(0)} $metricLabel',
                    GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
