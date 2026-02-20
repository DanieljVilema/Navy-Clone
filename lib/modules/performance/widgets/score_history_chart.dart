import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/pfa_result.dart';
import '../../../core/constants.dart';

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
          style: GoogleFonts.roboto(color: Colors.black54),
        ),
      );
    }

    // Sort to show chronological order (oldest to newest for x-axis)
    final sorted = List<PfaResult>.from(history)..sort((a, b) => a.fecha.compareTo(b.fecha));
    
    // Create spots
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
                color: Colors.grey.shade300,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) return const SizedBox();
                  final date = sorted[index].fecha;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: GoogleFonts.roboto(fontSize: 10, color: Colors.black54),
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
                    style: GoogleFonts.roboto(fontSize: 10, color: Colors.black54),
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
              color: AppColors.navyPrimary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.navyPrimary.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
