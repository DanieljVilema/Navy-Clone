import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  // Mock profile data
  String _rank = 'Marinero 1ro';
  String _name = 'Usuario';
  String _division = 'División de ejemplo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavyPFAApp.navyPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── PROFILE HEADER ──
              _buildProfileHeader(),
              const SizedBox(height: 20),
              // ── PFA HISTORY ──
              _buildSectionTitle('HISTORIAL DE EVALUACIONES'),
              const SizedBox(height: 12),
              _buildPFAHistory(),
              const SizedBox(height: 20),
              // ── STATS OVERVIEW ──
              _buildSectionTitle('RESUMEN DE RENDIMIENTO'),
              const SizedBox(height: 12),
              _buildStatsOverview(),
              const SizedBox(height: 20),
              // ── BCA HISTORY ──
              _buildSectionTitle('COMPOSICIÓN CORPORAL'),
              const SizedBox(height: 12),
              _buildBCAHistory(),
              const SizedBox(height: 20),
              // ── SETTINGS ──
              _buildSectionTitle('CONFIGURACIÓN'),
              const SizedBox(height: 12),
              _buildSettingsList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            NavyPFAApp.navyDark,
            NavyPFAApp.navyPrimary,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: NavyPFAApp.goldAccent,
                width: 3,
              ),
              color: NavyPFAApp.navyDark,
              boxShadow: [
                BoxShadow(
                  color: NavyPFAApp.goldAccent.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 44,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _name.toUpperCase(),
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: NavyPFAApp.goldAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NavyPFAApp.goldAccent.withOpacity(0.4),
              ),
            ),
            child: Text(
              _rank,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: NavyPFAApp.goldAccent,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _division,
            style: GoogleFonts.roboto(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 16),

          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MiniStat(label: 'Evaluaciones', value: '3'),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withOpacity(0.1),
              ),
              _MiniStat(label: 'Mejor Score', value: '82'),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withOpacity(0.1),
              ),
              _MiniStat(label: 'Nivel', value: 'BUENO'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: NavyPFAApp.goldAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: NavyPFAApp.goldAccent,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPFAHistory() {
    // Mock data
    final history = [
      {'cycle': 'Ciclo 1 - 2024', 'score': '82/100', 'level': 'BUENO', 'color': const Color(0xFF03A9F4)},
      {'cycle': 'Ciclo 2 - 2023', 'score': '68/100', 'level': 'SATISFACTORIO', 'color': const Color(0xFFFFC107)},
      {'cycle': 'Ciclo 1 - 2023', 'score': '55/100', 'level': 'INSUFICIENTE', 'color': const Color(0xFFF44336)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: history.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (item['color'] as Color).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item['color'] as Color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['cycle'] as String,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Score: ${item['score']}',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['level'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: item['color'] as Color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatsCard(
              icon: Icons.fitness_center_rounded,
              title: 'Push-ups',
              value: '35',
              subtitle: 'Mejor marca',
              color: const Color(0xFFFF7043),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatsCard(
              icon: Icons.accessibility_new_rounded,
              title: 'Curl-ups',
              value: '42',
              subtitle: 'Mejor marca',
              color: const Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatsCard(
              icon: Icons.directions_run_rounded,
              title: 'Cardio',
              value: '13:20',
              subtitle: 'Mejor tiempo',
              color: const Color(0xFF4A9FFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBCAHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BCAItem(label: 'Peso', value: '75 kg'),
                _BCAItem(label: 'Estatura', value: '175 cm'),
                _BCAItem(label: 'IMC', value: '24.5'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.06),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BCAItem(label: 'Cuello', value: '38 cm'),
                _BCAItem(label: 'Cintura', value: '82 cm'),
                _BCAItem(label: 'Estado', value: 'NORMAL'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _SettingTile(
            icon: Icons.edit_rounded,
            title: 'Editar Perfil',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Recordatorios de Entrenamiento',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.info_outline_rounded,
            title: 'Acerca de la App',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.description_outlined,
            title: 'Reglamentos Oficiales',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ── WIDGETS AUXILIARES ──

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: Colors.white38,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: 9,
              color: Colors.white30,
            ),
          ),
        ],
      ),
    );
  }
}

class _BCAItem extends StatelessWidget {
  final String label;
  final String value;

  const _BCAItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white38, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}