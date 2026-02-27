import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/shared/models/pfa_result.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class ScoreHistoryChart extends StatelessWidget {
  final List<PfaResult> history;

  const ScoreHistoryChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty || history.length < 2) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No hay suficientes datos para generar la gráfica.',
          style: GoogleFonts.inter(color: AppColors.darkTextSecondary),
        ),
      );
    }

    final sorted = List<PfaResult>.from(history)
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    final spots = List.generate(sorted.length, (i) {
      return FlSpot(i.toDouble(), sorted[i].notaTotal);
    });

    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.darkBorder,
                strokeWidth: 1,
              );
            },
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
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) {
                    return const SizedBox();
                  }
                  final date = sorted[index].fecha;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}/${date.month}',
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
                interval: 20,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.darkTextTertiary),
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (sorted.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
