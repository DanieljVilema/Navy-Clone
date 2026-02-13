import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen>
    with SingleTickerProviderStateMixin {
  // Tabs: PFA Calculator | BCA Calculator
  late TabController _tabController;

  // PFA Form
  String _selectedGender = 'M';
  String _selectedAgeGroup = '18-25';
  final _pushUpsController = TextEditingController();
  final _curlUpsController = TextEditingController();
  final _cardioMinController = TextEditingController();
  final _cardioSecController = TextEditingController();
  String _selectedCardioType = 'Trote 2.4km';

  // BCA Form
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _neckController = TextEditingController();
  final _waistController = TextEditingController();

  // Results
  String? _pfaResult;
  String? _pfaLevel;
  String? _bcaResult;
  String? _bcaStatus;

  final List<String> _ageGroups = [
    '18-25',
    '26-30',
    '31-35',
    '36-40',
    '41-45',
    '46-50',
    '51+'
  ];

  final List<String> _cardioTypes = [
    'Trote 2.4km',
    'Natación 450m',
    'Bicicleta 12min',
    'Remo 2000m',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pushUpsController.dispose();
    _curlUpsController.dispose();
    _cardioMinController.dispose();
    _cardioSecController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    super.dispose();
  }

  void _calculatePFA() {
    int pushUps = int.tryParse(_pushUpsController.text) ?? 0;
    int curlUps = int.tryParse(_curlUpsController.text) ?? 0;
    int cardioMin = int.tryParse(_cardioMinController.text) ?? 0;
    int cardioSec = int.tryParse(_cardioSecController.text) ?? 0;

    // Simplified scoring logic
    double pushUpScore = (pushUps / 50 * 20).clamp(0, 20);
    double curlUpScore = (curlUps / 60 * 20).clamp(0, 20);
    double totalCardioSec = (cardioMin * 60 + cardioSec).toDouble();
    double cardioScore = totalCardioSec > 0
        ? ((900 - totalCardioSec) / 900 * 60).clamp(0, 60)
        : 0;

    double totalScore = pushUpScore + curlUpScore + cardioScore;

    String level;
    if (totalScore >= 90) {
      level = 'EXCELENTE';
    } else if (totalScore >= 75) {
      level = 'SOBRESALIENTE';
    } else if (totalScore >= 60) {
      level = 'BUENO';
    } else if (totalScore >= 45) {
      level = 'SATISFACTORIO';
    } else {
      level = 'INSUFICIENTE';
    }

    setState(() {
      _pfaResult = '${totalScore.toStringAsFixed(1)} / 100';
      _pfaLevel = level;
    });
  }

  void _calculateBCA() {
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    double neck = double.tryParse(_neckController.text) ?? 0;
    double waist = double.tryParse(_waistController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      String status;
      if (bmi < 18.5) {
        status = 'BAJO PESO';
      } else if (bmi < 25) {
        status = 'NORMAL';
      } else if (bmi < 30) {
        status = 'SOBREPESO';
      } else {
        status = 'FUERA DE ESTÁNDAR';
      }

      setState(() {
        _bcaResult = 'IMC: ${bmi.toStringAsFixed(1)}';
        _bcaStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavyPFAApp.navyPrimary,
      appBar: AppBar(
        backgroundColor: NavyPFAApp.navyDark,
        title: Text(
          'CALCULADORA PFA',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: NavyPFAApp.goldAccent,
          indicatorWeight: 3,
          labelColor: NavyPFAApp.goldAccent,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(text: 'PFA SCORE'),
            Tab(text: 'BCA / IMC'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPFATab(),
          _buildBCATab(),
        ],
      ),
    );
  }

  Widget _buildPFATab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Info Section
          _buildSectionTitle('INFORMACIÓN PERSONAL'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: [
                // Gender selection
                Row(
                  children: [
                    Expanded(
                      child: _GenderButton(
                        label: 'MASCULINO',
                        icon: Icons.male_rounded,
                        isSelected: _selectedGender == 'M',
                        onTap: () => setState(() => _selectedGender = 'M'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GenderButton(
                        label: 'FEMENINO',
                        icon: Icons.female_rounded,
                        isSelected: _selectedGender == 'F',
                        onTap: () => setState(() => _selectedGender = 'F'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Age group
                _buildDropdown(
                  label: 'Grupo de Edad',
                  value: _selectedAgeGroup,
                  items: _ageGroups,
                  onChanged: (v) => setState(() => _selectedAgeGroup = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Events Section
          _buildSectionTitle('EVENTOS DE PRUEBA'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _pushUpsController,
                  label: 'Flexiones (Push-ups)',
                  icon: Icons.fitness_center_rounded,
                  suffix: 'reps',
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _curlUpsController,
                  label: 'Abdominales (Curl-ups)',
                  icon: Icons.accessibility_new_rounded,
                  suffix: 'reps',
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Tipo de Cardio',
                  value: _selectedCardioType,
                  items: _cardioTypes,
                  onChanged: (v) =>
                      setState(() => _selectedCardioType = v!),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cardioMinController,
                        label: 'Min',
                        icon: Icons.timer_outlined,
                        suffix: 'min',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _cardioSecController,
                        label: 'Seg',
                        icon: Icons.timer_outlined,
                        suffix: 'seg',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Calculate Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _calculatePFA,
              style: ElevatedButton.styleFrom(
                backgroundColor: NavyPFAApp.goldAccent,
                foregroundColor: NavyPFAApp.navyDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calculate_rounded, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'CALCULAR PFA SCORE',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Result
          if (_pfaResult != null) _buildResultCard(_pfaResult!, _pfaLevel!),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBCATab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('COMPOSICIÓN CORPORAL'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: [
                _buildTextField(
                  controller: _heightController,
                  label: 'Estatura',
                  icon: Icons.height_rounded,
                  suffix: 'cm',
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _weightController,
                  label: 'Peso',
                  icon: Icons.monitor_weight_outlined,
                  suffix: 'kg',
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _neckController,
                  label: 'Circunferencia de Cuello',
                  icon: Icons.circle_outlined,
                  suffix: 'cm',
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _waistController,
                  label: 'Circunferencia de Cintura',
                  icon: Icons.circle_outlined,
                  suffix: 'cm',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _calculateBCA,
              style: ElevatedButton.styleFrom(
                backgroundColor: NavyPFAApp.goldAccent,
                foregroundColor: NavyPFAApp.navyDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calculate_rounded, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'CALCULAR BCA',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_bcaResult != null)
            _buildResultCard(_bcaResult!, _bcaStatus!),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── HELPER WIDGETS ──

  Widget _buildSectionTitle(String title) {
    return Row(
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
            color: Colors.white60,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.roboto(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.white38, fontSize: 13),
        prefixIcon: Icon(icon, color: NavyPFAApp.goldAccent, size: 20),
        suffixText: suffix,
        suffixStyle: GoogleFonts.roboto(color: Colors.white30, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NavyPFAApp.goldAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: NavyPFAApp.navyDark,
        style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(color: Colors.white38, fontSize: 13),
          border: InputBorder.none,
        ),
        items: items.map((e) {
          return DropdownMenuItem(value: e, child: Text(e));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildResultCard(String result, String level) {
    Color levelColor;
    IconData levelIcon;
    switch (level) {
      case 'EXCELENTE':
      case 'NORMAL':
        levelColor = const Color(0xFF4CAF50);
        levelIcon = Icons.emoji_events_rounded;
        break;
      case 'SOBRESALIENTE':
        levelColor = const Color(0xFF2196F3);
        levelIcon = Icons.star_rounded;
        break;
      case 'BUENO':
        levelColor = const Color(0xFF03A9F4);
        levelIcon = Icons.thumb_up_rounded;
        break;
      case 'SATISFACTORIO':
      case 'SOBREPESO':
        levelColor = const Color(0xFFFFC107);
        levelIcon = Icons.warning_rounded;
        break;
      default:
        levelColor = const Color(0xFFF44336);
        levelIcon = Icons.dangerous_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            levelColor.withOpacity(0.2),
            levelColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: levelColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(levelIcon, size: 48, color: levelColor),
          const SizedBox(height: 12),
          Text(
            result,
            style: GoogleFonts.roboto(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: levelColor,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── BOTÓN DE GÉNERO ──
class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? NavyPFAApp.goldAccent.withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? NavyPFAApp.goldAccent
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? NavyPFAApp.goldAccent : Colors.white38,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? NavyPFAApp.goldAccent : Colors.white38,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}