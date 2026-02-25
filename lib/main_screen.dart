import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modules/home/home_screen.dart';
import 'modules/services/services_screen.dart';
import 'modules/chatbot/chatbot_screen.dart';
import 'modules/nutrition/nutrition_screen.dart';
import 'modules/videos/videos_screen.dart';
import 'modules/training/training_screen.dart';
import 'modules/offline/offline_screen.dart';
import 'modules/exercise_tracking/exercise_tracking_screen.dart';
import 'core/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = const HomeScreen();
  String _currentTitle = 'Bienvenido';

  void _navigateTo(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _currentTitle,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.3,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.darkTextPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.darkTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _currentScreen,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── DRAWER HEADER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(Radii.m),
                    ),
                    child: const Icon(
                      Icons.anchor_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: Spacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ArmadaFit',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Evaluación Física',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── SEARCH BAR ──
            Padding(
              padding: const EdgeInsets.all(Spacing.m),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkCardSec,
                  borderRadius: BorderRadius.circular(Radii.m),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: Spacing.m),
                    const Icon(Icons.search, size: 20, color: AppColors.darkTextTertiary),
                    const SizedBox(width: Spacing.s),
                    Text(
                      'Buscar',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.darkTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── NAVIGATION ITEMS ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Bienvenido',
                    isSelected: _currentTitle == 'Bienvenido',
                    onTap: () => _navigateTo(const HomeScreen(), 'Bienvenido'),
                  ),
                  _DrawerItem(
                    icon: Icons.sports_score_outlined,
                    title: 'Registro & Evaluación',
                    isSelected: _currentTitle == 'Registro & Evaluación',
                    onTap: () => _navigateTo(
                        const ExerciseTrackingScreen(), 'Registro & Evaluación'),
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Consultas I.A.',
                    isSelected: _currentTitle == 'Consultas I.A.',
                    onTap: () =>
                        _navigateTo(const ChatbotScreen(), 'Consultas I.A.'),
                  ),
                  _DrawerItem(
                    icon: Icons.play_circle_outline,
                    title: 'Videos de Entrenamiento',
                    isSelected: _currentTitle == 'Videos de Entrenamiento',
                    onTap: () =>
                        _navigateTo(const VideosScreen(), 'Videos de Entrenamiento'),
                  ),
                  _DrawerItem(
                    icon: Icons.policy_outlined,
                    title: 'Reglamentos y Normativas',
                    isSelected: _currentTitle == 'Reglamentos y Normativas',
                    onTap: () =>
                        _navigateTo(const ServicesScreen(), 'Reglamentos y Normativas'),
                  ),
                  _DrawerItem(
                    icon: Icons.restaurant_outlined,
                    title: 'Nutrición',
                    isSelected: _currentTitle == 'Nutrición',
                    onTap: () => _navigateTo(const NutritionScreen(), 'Nutrición'),
                  ),
                  _DrawerItem(
                    icon: Icons.fitness_center_outlined,
                    title: 'Biblioteca de Entrenamiento',
                    isSelected: _currentTitle == 'Biblioteca de Entrenamiento',
                    onTap: () => _navigateTo(
                        TrainingScreen(), 'Biblioteca de Entrenamiento'),
                  ),
                  _DrawerItem(
                    icon: Icons.cloud_off_outlined,
                    title: 'Recursos Sin Conexión',
                    isSelected: _currentTitle == 'Recursos Sin Conexión',
                    onTap: () => _navigateTo(const OfflineScreen(), 'Recursos Sin Conexión'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── DRAWER ITEM (Dark ArmadaFit Style) ──
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 14),
          child: Row(
            children: [
              // Icon container (40x40, rounded, bg cardBgSecondary)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.darkCardSec,
                  borderRadius: BorderRadius.circular(Radii.m),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(width: Spacing.m),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.darkTextPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.darkTextTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}