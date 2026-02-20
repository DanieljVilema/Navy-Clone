import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/pfa_history_provider.dart';
import '../../core/constants.dart';
import 'widgets/score_history_chart.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final historyProvider = context.watch<PfaHistoryProvider>();
    final user = userProvider.profile;
    final latestHistory = historyProvider.latestResult;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── PROFILE CARD ──
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.navyPrimary.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.navyPrimary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: AppColors.navyPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nombre ?? 'Usuario',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Revisa tu progreso y evaluaciones',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // ── PFA HISTORY ──
          _buildSectionHeader('Historial de Evaluaciones'),
          
          if (!historyProvider.hasHistory)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Aún no hay evaluaciones registradas. Utiliza el Simulador para guardar tus resultados.',
                style: GoogleFonts.roboto(color: Colors.black54),
              ),
            )
          else ...[
            ...historyProvider.history.take(5).map((r) => _HistoryItem(
              cycle: '${r.fecha.day.toString().padLeft(2, '0')}/${r.fecha.month.toString().padLeft(2, '0')}/${r.fecha.year}',
              score: '${r.notaTotal.toStringAsFixed(1)} / 100',
              level: r.nivel,
            )),
            const SizedBox(height: 16),
            _buildSectionHeader('Evolución del Puntaje'),
            ScoreHistoryChart(history: historyProvider.history),
          ],

          // ── PERSONAL RECORDS ──
          _buildSectionHeader('Mejores Marcas'),

          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _RecordCard(label: 'Flexiones', value: latestHistory?.flexionesRaw?.toString() ?? '-', unit: 'reps'),
                const SizedBox(width: 12),
                _RecordCard(label: 'Abdominales', value: latestHistory?.abdominalesRaw?.toString() ?? '-', unit: 'reps'),
                const SizedBox(width: 12),
                _RecordCard(
                  label: 'Cardio', 
                  value: latestHistory?.cardioSegundos != null 
                      ? '${latestHistory!.cardioSegundos! ~/ 60}:${(latestHistory.cardioSegundos! % 60).toString().padLeft(2, '0')}' 
                      : '-', 
                  unit: 'tiempo'
                ),
              ],
            ),
          ),

          // ── BCA DATA ──
          _buildSectionHeader('Información Biométrica'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _BCARow(label: 'Peso', value: user?.pesoLb?.toStringAsFixed(1) ?? '-'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Altura', value: user?.alturaPulg?.toStringAsFixed(1) ?? '-'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'IMC Último', value: latestHistory?.imc?.toStringAsFixed(1) ?? '-'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Estado BCA', value: latestHistory?.estadoBca ?? '-'),
              ],
            ),
          ),

          // ── SETTINGS ──
          _buildSectionHeader('Ajustes y Más'),

          _SettingItem(
            icon: Icons.edit_outlined,
            title: 'Editar Perfil',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.notifications_outlined,
            title: 'Recordatorios de Entrenamiento',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.info_outline,
            title: 'Acerca de la App',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.description_outlined,
            title: 'Reglamentos Oficiales',
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.navyPrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── HISTORY ITEM ──
class _HistoryItem extends StatelessWidget {
  final String cycle;
  final String score;
  final String level;

  const _HistoryItem({
    required this.cycle,
    required this.score,
    required this.level,
  });

  Color _getLevelColor(String lvl) {
    switch (lvl) {
      case 'SOBRESALIENTE':
        return const Color(0xFF4CAF50);
      case 'EXCELENTE':
        return const Color(0xFF2196F3);
      case 'BUENO':
        return const Color(0xFF03A9F4);
      case 'SATISFACTORIO':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFFF44336);
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(level);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: levelColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cycle,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Puntaje: $score',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: levelColor.withOpacity(0.3)),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: levelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200, indent: 38),
      ],
    );
  }
}

// ── RECORD CARD ──
class _RecordCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _RecordCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.navyPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              unit,
              style: GoogleFonts.roboto(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── BCA ROW ──
class _BCARow extends StatelessWidget {
  final String label;
  final String value;

  const _BCARow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ── SETTING ITEM ──
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
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
                  Icon(icon, size: 22, color: Colors.grey.shade600),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200, indent: 56),
      ],
    );
  }
}