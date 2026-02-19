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
              'Todos los recursos de políticas del Programa de Preparación Física de la Armada, incluyendo lo siguiente:',
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
            title: 'Guía del Programa de Preparación Física',
            subtitle: 'Reglamento General de Deportes',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Guía de Evaluación Física',
            subtitle: 'Guía de políticas actualizada y preguntas frecuentes',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Estándares de Control de Peso',
            subtitle: 'Estándares de Evaluación de Composición Corporal',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Estándares de Pruebas Físicas',
            subtitle: 'Estándares de eventos de la Prueba de Preparación Física',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Guía del Líder de Fitness del Comando',
            subtitle: 'Responsabilidades y procedimientos',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Guía de Usuario del Sistema de Gestión',
            subtitle: 'Sistema de Gestión de Información de Preparación Física',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Programa de Mejora Física (FEP)',
            subtitle: 'Requisitos y procedimientos del FEP',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Exenciones Médicas',
            subtitle: 'Guía de autorización médica y exenciones',
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Mensajes Oficiales y Radiogramas',
            subtitle: 'Mensajes relacionados con la Evaluación Física',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── ADDITIONAL RESOURCES SECTION ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey.shade50,
            child: Text(
              'Recursos Adicionales',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          _PolicyItem(
            title: 'Sitio Web de Fitness Naval',
            subtitle: 'www.armada.mil.ec',
            trailing: Icons.open_in_new,
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Dirección de Personal',
            subtitle: 'Recursos del comando de personal',
            trailing: Icons.open_in_new,
            onTap: () {},
          ),
          _PolicyItem(
            title: 'Sanidad Naval',
            subtitle: 'Recursos de salud y bienestar',
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
