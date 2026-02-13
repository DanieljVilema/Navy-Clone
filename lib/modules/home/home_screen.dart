import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // ── NAVY PFA LOGO ──
            _buildLogo(),
            const SizedBox(height: 28),

            // ── WELCOME TEXT ──
            _buildWelcomeText(),
            const SizedBox(height: 28),

            // ── MENU ITEMS LIST ──
            _buildMenuList(context),
            const SizedBox(height: 32),

            // ── FOOTER ──
            _buildFooter(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Star logo with CULTURE AND FORCE RESILIENCE text
        SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Star background
              Icon(
                Icons.star,
                size: 140,
                color: NavyPFAApp.goldAccent,
              ),
              // Anchor in center
              const Icon(
                Icons.anchor_rounded,
                size: 50,
                color: Color(0xFF001F5B),
              ),
              // Top text
              Positioned(
                top: 12,
                child: Text(
                  'CULTURE AND',
                  style: GoogleFonts.roboto(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: NavyPFAApp.navyPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              // Bottom text
              Positioned(
                bottom: 12,
                child: Text(
                  'FORCE RESILIENCE',
                  style: GoogleFonts.roboto(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: NavyPFAApp.navyPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAVY',
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: NavyPFAApp.navyPrimary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NavyPFAApp.navyPrimary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'OFFICE',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the Official Navy PFA App!',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text:
                      'This app provides "one-stop shopping" for all U.S. Navy Physical Readiness Program information, including the following:',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _MenuListItem(
            icon: Icons.calculate_outlined,
            title: 'PFA Calculator',
            onTap: () {},
          ),
          _MenuListItem(
            icon: Icons.play_circle_outline,
            title: 'PFA Demonstration Videos',
            onTap: () {},
          ),
          _MenuListItem(
            icon: Icons.policy_outlined,
            title: 'Policy Resources',
            onTap: () {},
          ),
          _MenuListItem(
            icon: Icons.restaurant_outlined,
            title: 'Nutrition Guidance',
            onTap: () {},
          ),
          _MenuListItem(
            icon: Icons.fitness_center_outlined,
            title: 'NOFFS Workout Library',
            onTap: () {},
          ),
          _MenuListItem(
            icon: Icons.cloud_off_outlined,
            title: 'Offline Resources',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: NavyPFAApp.navyPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'The Official U.S. Navy PFA Application',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Navy Culture and Force Resilience Office',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── MENU LIST ITEM ──
class _MenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuListItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: NavyPFAApp.navyPrimary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade200,
          indent: 52,
        ),
      ],
    );
  }
}