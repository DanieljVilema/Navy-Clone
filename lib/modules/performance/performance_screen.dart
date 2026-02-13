import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    color: NavyPFAApp.navyPrimary.withOpacity(0.1),
                    border: Border.all(
                      color: NavyPFAApp.navyPrimary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: NavyPFAApp.navyPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Profile',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View your PFA history and performance data',
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
          _buildSectionHeader('PFA History'),

          _HistoryItem(
            cycle: 'Cycle 1 - 2024',
            score: '82 / 100',
            level: 'GOOD',
            levelColor: const Color(0xFF03A9F4),
          ),
          _HistoryItem(
            cycle: 'Cycle 2 - 2023',
            score: '68 / 100',
            level: 'SATISFACTORY',
            levelColor: const Color(0xFFFFC107),
          ),
          _HistoryItem(
            cycle: 'Cycle 1 - 2023',
            score: '55 / 100',
            level: 'FAILURE',
            levelColor: const Color(0xFFF44336),
          ),

          // ── PERSONAL RECORDS ──
          _buildSectionHeader('Personal Records'),

          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _RecordCard(label: 'Push-ups', value: '35', unit: 'reps'),
                const SizedBox(width: 12),
                _RecordCard(label: 'Curl-ups', value: '42', unit: 'reps'),
                const SizedBox(width: 12),
                _RecordCard(label: 'Cardio', value: '13:20', unit: 'time'),
              ],
            ),
          ),

          // ── BCA DATA ──
          _buildSectionHeader('BCA Information'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _BCARow(label: 'Weight', value: '75 kg'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Height', value: '175 cm'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'BMI', value: '24.5'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Neck', value: '38 cm'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Waist', value: '82 cm'),
                Divider(height: 1, color: Colors.grey.shade200),
                _BCARow(label: 'Status', value: 'WITHIN STANDARDS'),
              ],
            ),
          ),

          // ── SETTINGS ──
          _buildSectionHeader('Settings'),

          _SettingItem(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.notifications_outlined,
            title: 'Training Reminders',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.info_outline,
            title: 'About the App',
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.description_outlined,
            title: 'Official Regulations',
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
          color: NavyPFAApp.navyPrimary,
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
  final Color levelColor;

  const _HistoryItem({
    required this.cycle,
    required this.score,
    required this.level,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
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
                      'Score: $score',
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
                color: NavyPFAApp.navyPrimary,
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