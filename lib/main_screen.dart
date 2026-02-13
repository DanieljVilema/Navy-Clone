import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'modules/home/home_screen.dart';
import 'modules/simulator/simulator_screen.dart';
import 'modules/services/services_screen.dart';
import 'modules/performance/performance_screen.dart';
import 'modules/training/training_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = const HomeScreen();
  String _currentTitle = 'Welcome';

  void _navigateTo(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context); // close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NavyPFAApp.navyAppBar,
        title: Text(
          _currentTitle,
          style: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── DRAWER HEADER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: NavyPFAApp.navyAppBar,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo/icon
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.anchor_rounded,
                          color: NavyPFAApp.goldAccent,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Official Navy PFA',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '3.0.29',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── SEARCH BAR ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, size: 20, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey.shade500,
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
                    title: 'Welcome',
                    isSelected: _currentTitle == 'Welcome',
                    onTap: () => _navigateTo(const HomeScreen(), 'Welcome'),
                  ),
                  const Divider(height: 1),
                  _DrawerItem(
                    icon: Icons.calculate_outlined,
                    title: 'PFA Calculator',
                    isSelected: _currentTitle == 'PFA Calculator',
                    onTap: () =>
                        _navigateTo(const SimulatorScreen(), 'PFA Calculator'),
                  ),
                  const Divider(height: 1),

                  // PFA Demonstrations - expandable section
                  _DrawerExpandableItem(
                    icon: Icons.play_circle_outline,
                    title: 'PFA Demonstrations',
                    children: [
                      'BCA Waist Measurement Demo (Male)',
                      'BCA Waist Measurement Demo (Female)',
                      'PRT Push-up Demo',
                      'PRT Forearm Plank Demo',
                      'PRT 2000M Rower Demo',
                    ],
                  ),
                  const Divider(height: 1),

                  _DrawerItem(
                    icon: Icons.download_outlined,
                    title: 'Manage Downloaded Videos',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloaded Videos - Coming Soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  _DrawerItem(
                    icon: Icons.policy_outlined,
                    title: 'Policy Resources',
                    isSelected: _currentTitle == 'Policy Resources',
                    onTap: () =>
                        _navigateTo(const ServicesScreen(), 'Policy Resources'),
                  ),
                  const Divider(height: 1),

                  _DrawerItem(
                    icon: Icons.restaurant_outlined,
                    title: 'Nutrition',
                    isSelected: _currentTitle == 'Nutrition',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nutrition - Coming Soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  _DrawerItem(
                    icon: Icons.fitness_center_outlined,
                    title: 'NOFFS Workout Library',
                    isSelected: _currentTitle == 'NOFFS Workout Library',
                    onTap: () => _navigateTo(
                        const TrainingScreen(), 'NOFFS Workout Library'),
                  ),
                  const Divider(height: 1),

                  _DrawerItem(
                    icon: Icons.cloud_off_outlined,
                    title: 'Offline Resources',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Offline Resources - Coming Soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── DRAWER ITEM ──
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
      color: isSelected ? Colors.blue.shade50 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? NavyPFAApp.navyPrimary
                    : Colors.grey.shade700,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? NavyPFAApp.navyPrimary
                        : Colors.grey.shade800,
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
    );
  }
}

// ── EXPANDABLE DRAWER ITEM ──
class _DrawerExpandableItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> children;

  const _DrawerExpandableItem({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  State<_DrawerExpandableItem> createState() => _DrawerExpandableItemState();
}

class _DrawerExpandableItemState extends State<_DrawerExpandableItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 22,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            color: Colors.grey.shade50,
            child: Column(
              children: widget.children.map((child) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$child - Coming Soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 54, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            child,
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}