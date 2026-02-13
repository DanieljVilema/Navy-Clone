import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── HEADER DESCRIPTION ──
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade50,
            child: Text(
              'All U.S. Navy Physical Readiness Program policy resources, including the following:',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // ── POLICY RESOURCE ITEMS ──
          _PolicyItem(
            title: 'Physical Readiness Program Guide',
            subtitle: 'OPNAVINST 6110.1K',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'PFA Guidance',
            subtitle: 'Updated policy guidance and FAQs',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'BCA Standards',
            subtitle: 'Body Composition Assessment standards',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'PRT Standards',
            subtitle: 'Physical Readiness Test event standards',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Command Fitness Leader Guide',
            subtitle: 'CFL responsibilities and procedures',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'PRIMS User Guide',
            subtitle: 'Physical Readiness Information Management System',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Fitness Enhancement Program (FEP)',
            subtitle: 'FEP requirements and procedures',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Medical Waivers & Exemptions',
            subtitle: 'Medical clearance and exemption guidance',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'NAVADMIN Messages',
            subtitle: 'PFA-related NAVADMIN messages',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── ADDITIONAL RESOURCES SECTION ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey.shade50,
            child: Text(
              'Additional Resources',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          _PolicyItem(
            title: 'Navy Fitness Website',
            subtitle: 'www.navyfitness.org',
            trailing: Icons.open_in_new,
            onTap: () {},
          ),
          _PolicyItem(
            title: 'MyNavy HR',
            subtitle: 'Personnel command resources',
            trailing: Icons.open_in_new,
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Navy Medicine',
            subtitle: 'Health and wellness resources',
            trailing: Icons.open_in_new,
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? trailing;
  final VoidCallback onTap;

  const _PolicyItem({
    required this.title,
    required this.subtitle,
    this.trailing,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    trailing ?? Icons.chevron_right,
                    size: 20,
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
          indent: 20,
        ),
      ],
    );
  }
}
