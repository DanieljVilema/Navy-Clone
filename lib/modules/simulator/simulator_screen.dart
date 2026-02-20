import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/simulator_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/pfa_history_provider.dart';
import '../../services/scoring_service.dart';
import '../../core/constants.dart';

// Dark theme helper colors
const _bg = AppColors.darkBg;
const _card = AppColors.darkCard;
const _cardSec = AppColors.darkCardSec;
const _textPri = AppColors.darkTextPrimary;
const _textSec = AppColors.darkTextSecondary;
const _textTer = AppColors.darkTextTertiary;
const _border = AppColors.darkBorder;

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // BCA Form (metric: cm, kg)
  final _heightController = TextEditingController(); // cm
  final _waistController = TextEditingController(); // cm
  final _weightController = TextEditingController(); // kg

  // PFA Events
  final _pushUpsController = TextEditingController();
  final _curlUpsController = TextEditingController();
  final _cardioMinController = TextEditingController();
  final _cardioSecController = TextEditingController();

  final List<String> _genders = ['Masculino', 'Femenino'];
  final List<String> _ageGroups = [
    '17-19', '20-24', '25-29', '30-34', '35-39',
    '40-44', '45-49', '50-54', '55-59', '60-64', '65+'
  ];
  final List<String> _altitudes = ['Bajo 1500m', 'Sobre 1500m'];
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
    _waistController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculatePFA() {
    final simProvider = context.read<SimulatorProvider>();
    final userProvider = context.read<UserProvider>();
    final historyProvider = context.read<PfaHistoryProvider>();
    final scoringService = context.read<ScoringService>();

    int pushUps = int.tryParse(_pushUpsController.text) ?? 0;
    int curlUps = int.tryParse(_curlUpsController.text) ?? 0;
    int cardioMin = int.tryParse(_cardioMinController.text) ?? 0;
    int cardioSec = int.tryParse(_cardioSecController.text) ?? 0;
    
    // User enters metric (cm, kg) → convert to imperial for scoring engine
    double? heightCm = double.tryParse(_heightController.text);
    double? waistCm = double.tryParse(_waistController.text);
    double? weightKg = double.tryParse(_weightController.text);

    double? heightInch = heightCm != null ? heightCm / 2.54 : null;
    double? waistInch = waistCm != null ? waistCm / 2.54 : null;
    double? weightLb = weightKg != null ? weightKg * 2.205 : null;

    simProvider.calculate(
      scorer: scoringService,
      userId: userProvider.profile?.id ?? 1,
      flexiones: pushUps,
      abdominales: curlUps,
      cardioMinutos: cardioMin,
      cardioSegundos: cardioSec,
      alturaPulg: heightInch,
      cinturaPulg: waistInch,
      pesoLb: weightLb,
    );

    if (simProvider.lastResult != null) {
      historyProvider.addResult(simProvider.lastResult!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── TABS ──
          Container(
            color: _card,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: _textSec,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Bienvenido'),
                Tab(text: 'Simulador'),
              ],
            ),
          ),

          // ── TAB CONTENT ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWelcomeTab(),
                _buildCalculatorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulador de Evaluación Física',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textPri,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Esta herramienta le permite calcular su nota de Evaluación Física basándose en el Control de Peso (IMC) y las Pruebas Físicas.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _textSec,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Presione la pestaña "Simulador" arriba para comenzar.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── DEMOGRAPHIC SELECTORS ROW ──
          _buildDemographicRow(context),
          const SizedBox(height: 20),

          // ── BODY COMPOSITION ASSESSMENT (BCA) ──
          _buildSectionLabel('Control de Peso e Índice de Masa Corporal (IMC)'),
          const SizedBox(height: 8),
          _buildBCAForm(),
          const SizedBox(height: 8),

          // ── BCA RESULTS TABLE ──
          _buildBCAResultsTable(context),
          const SizedBox(height: 20),

          // ── PHYSICAL READINESS TEST (PRT) ──
          _buildSectionLabel('Pruebas Físicas'),
          const SizedBox(height: 8),
          _buildPRTForm(context),
          const SizedBox(height: 20),

          // ── CALCULATE BUTTON ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _calculatePFA,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Calcular Nota de Evaluación',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          if (context.watch<SimulatorProvider>().lastResult != null) ...[
            const SizedBox(height: 16),
            _buildPFAResultCard(context),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDemographicRow(BuildContext context) {
    final provider = context.watch<SimulatorProvider>();
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactDropdown(
              label: 'Sexo',
              value: provider.genero,
              items: _genders,
              onChanged: (v) => provider.updateGenero(v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildCompactDropdown(
              label: 'Edad',
              value: provider.grupoEdad,
              items: _ageGroups,
              onChanged: (v) => provider.updateGrupoEdad(v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildCompactDropdown(
              label: 'Altitud',
              value: provider.altitud,
              items: _altitudes,
              onChanged: (v) => provider.updateAltitud(v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              isDense: true,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.black87,
              ),
              icon: Icon(Icons.arrow_drop_down,
                  size: 18, color: Colors.grey.shade600),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 10),
      decoration: BoxDecoration(
        color: _cardSec,
        border: Border(
          bottom: BorderSide(color: _border),
          top: BorderSide(color: _border),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPri,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_up, size: 20, color: _textTer),
        ],
      ),
    );
  }

  Widget _buildBCAForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildFormInputRow('Altura', _heightController, 'cm', Icons.height),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('Ingrese su altura en centímetros', italic: true,
              subtext: 'Ej: 170 para 1.70m'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormInputRow('Cintura', _waistController, 'cm', Icons.straighten),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('Ingrese cintura en centímetros', italic: true,
              subtext: 'Medida a la altura del ombligo'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormInputRow('Peso', _weightController, 'kg',
              Icons.monitor_weight_outlined),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('', italic: false,
              subtext: 'Ingrese su peso en kilogramos'),
        ],
      ),
    );
  }

  Widget _buildFormInputRow(
      String label, TextEditingController controller, String unit, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 14),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.navyPrimary),
                ),
                suffixText: unit,
                suffixStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildFormRowText(String text,
      {bool italic = false, String? subtext}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text.isNotEmpty)
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                color: Colors.grey.shade500,
              ),
            ),
          if (subtext != null) ...[
            const SizedBox(height: 2),
            Text(
              subtext,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBCAResultsTable(BuildContext context) {
    final result = context.watch<SimulatorProvider>().lastResult;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.monitor_weight_outlined, size: 20, color: AppColors.navyPrimary),
                const SizedBox(width: 8),
                Text(
                  'Resultados del Control de Peso',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // ── RATIO CINTURA/ALTURA ──
          if (result?.cinturaRatio != null)
            _buildBCAMetricCard(
              titulo: 'Relación Cintura / Altura',
              valor: result!.cinturaRatio!,
              maximo: 0.5500,
              unidad: '',
              decimales: 4,
              aprobado: result.estadoBca == 'APROBADO',
              iconData: Icons.straighten,
              recomendacion: result.estadoBca == 'APROBADO'
                  ? '✅ Su relación cintura/altura está dentro del estándar permitido.'
                  : '⚠️ Su relación cintura/altura excede el límite de 0.5500. Reduzca la circunferencia de cintura mediante ejercicio cardiovascular y dieta controlada.',
            ),

          // ── IMC ──
          if (result?.imc != null)
            _buildBCAMetricCard(
              titulo: 'Índice de Masa Corporal (IMC)',
              valor: result!.imc!,
              maximo: 27.0,
              unidad: 'kg/m²',
              decimales: 1,
              aprobado: result.imc! <= 27.0,
              iconData: Icons.speed,
              recomendacion: result.imc! <= 18.5
                  ? '💡 Su IMC indica bajo peso. Considere aumentar su ingesta calórica con alimentación balanceada.'
                  : result.imc! <= 24.9
                      ? '✅ Su IMC está en rango saludable. Mantenga su rutina actual.'
                      : result.imc! <= 27.0
                          ? '⚠️ Su IMC está en rango de sobrepeso pero dentro del límite naval. Vigile su alimentación.'
                          : '🔴 Su IMC supera el límite de 27.0. Se recomienda un plan de pérdida de peso gradual: reduzca 500 calorías diarias y aumente la actividad cardiovascular.',
            ),

          if (result == null || (result.cinturaRatio == null && result.imc == null))
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ingrese los datos de altura, cintura y peso para ver los resultados.',
                style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBCAMetricCard({
    required String titulo,
    required double valor,
    required double maximo,
    required String unidad,
    required int decimales,
    required bool aprobado,
    required IconData iconData,
    required String recomendacion,
  }) {
    final color = aprobado ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final ratio = (valor / maximo).clamp(0.0, 1.5);
    final barRatio = ratio.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(titulo, style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  aprobado ? 'APROBADO' : 'NO APROBADO',
                  style: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: barRatio,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${valor.toStringAsFixed(decimales)} / ${maximo.toStringAsFixed(decimales)} $unidad',
                style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Recommendation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Text(
              recomendacion,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.black87, height: 1.4),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildPRTForm(BuildContext context) {
    final provider = context.watch<SimulatorProvider>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Push-ups section header
          _buildPRTSectionHeader('Flexiones de Pecho'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              controller: _pushUpsController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ingrese repeticiones',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 13, color: Colors.grey.shade400),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // Forearm Plank (or Curl-ups)
          _buildPRTSectionHeader('Plancha Abdominal / Abdominales'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              controller: _curlUpsController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ingrese tiempo (mm:ss) o reps',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 13, color: Colors.grey.shade400),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // Cardio
          _buildPRTSectionHeader('Evento Cardiovascular'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.tipoCardio,
                      isExpanded: true,
                      isDense: true,
                      style: GoogleFonts.roboto(
                          fontSize: 13, color: Colors.black87),
                      items: _cardioTypes.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (v) => provider.updateTipoCardio(v!),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cardioMinController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.roboto(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Min',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 13, color: Colors.grey.shade400),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _cardioSecController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.roboto(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Seg',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 13, color: Colors.grey.shade400),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPRTSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_up, size: 18, color: Colors.grey.shade500),
        ],
      ),
    );
  }

  Widget _buildPFAResultCard(BuildContext context) {
    final result = context.watch<SimulatorProvider>().lastResult;
    if (result == null) return const SizedBox.shrink();

    Color levelColor;
    IconData levelIcon;
    switch (result.nivel) {
      case 'SOBRESALIENTE':
        levelColor = const Color(0xFF4CAF50);
        levelIcon = Icons.emoji_events_rounded;
        break;
      case 'EXCELENTE':
        levelColor = const Color(0xFF2196F3);
        levelIcon = Icons.star_rounded;
        break;
      case 'BUENO':
        levelColor = const Color(0xFF03A9F4);
        levelIcon = Icons.thumb_up_rounded;
        break;
      case 'SATISFACTORIO':
        levelColor = const Color(0xFFFFC107);
        levelIcon = Icons.warning_rounded;
        break;
      default:
        levelColor = const Color(0xFFF44336);
        levelIcon = Icons.dangerous_rounded;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // ── HEADER: Total Score ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [levelColor.withValues(alpha: 0.15), levelColor.withValues(alpha: 0.05)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Icon(levelIcon, size: 40, color: levelColor),
                const SizedBox(height: 8),
                Text(
                  '${result.notaTotal.toStringAsFixed(1)} / 100',
                  style: GoogleFonts.roboto(
                    fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    result.nivel,
                    style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w800, color: levelColor, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ── BREAKDOWN: Push-ups ──
          _buildEventBreakdown(
            titulo: 'Flexiones de Pecho',
            icon: Icons.fitness_center,
            nota: result.notaFlexiones,
            rawValue: '${result.flexionesRaw ?? 0} repeticiones',
            recomendacion: _getPushUpRecommendation(result.notaFlexiones, result.flexionesRaw ?? 0),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ── BREAKDOWN: Abs ──
          _buildEventBreakdown(
            titulo: 'Plancha / Abdominales',
            icon: Icons.accessibility_new,
            nota: result.notaAbdominales,
            rawValue: '${result.abdominalesRaw ?? 0} repeticiones',
            recomendacion: _getAbsRecommendation(result.notaAbdominales, result.abdominalesRaw ?? 0),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ── BREAKDOWN: Cardio ──
          _buildEventBreakdown(
            titulo: 'Evento Cardiovascular (${result.tipoCardio})',
            icon: Icons.directions_run,
            nota: result.notaCardio,
            rawValue: _formatCardioTime(result.cardioSegundos ?? 0),
            recomendacion: _getCardioRecommendation(result.notaCardio, result.cardioSegundos ?? 0),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEventBreakdown({
    required String titulo,
    required IconData icon,
    required double nota,
    required String rawValue,
    required String recomendacion,
  }) {
    final color = nota >= 90
        ? const Color(0xFF4CAF50)
        : nota >= 75
            ? const Color(0xFF2196F3)
            : nota >= 60
                ? const Color(0xFF03A9F4)
                : nota >= 45
                    ? const Color(0xFFFFC107)
                    : const Color(0xFFF44336);

    final barValue = (nota / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.navyPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(titulo, style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${nota.toStringAsFixed(1)} pts',
                  style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(rawValue, style: GoogleFonts.roboto(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: barValue,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Text(
              recomendacion,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCardioTime(int totalSeconds) {
    final min = totalSeconds ~/ 60;
    final sec = totalSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')} minutos';
  }

  String _getPushUpRecommendation(double nota, int reps) {
    if (nota >= 90) {
      return '🏆 ¡Excelente rendimiento en flexiones! Está por encima del estándar. Mantenga su entrenamiento actual.';
    } else if (nota >= 75) {
      return '👍 Buen rendimiento. Para alcanzar el nivel Sobresaliente, aumente ${(reps * 0.2).ceil()} repeticiones más. Agregue series de flexiones inclinadas y diamante.';
    } else if (nota >= 60) {
      return '📈 Rendimiento aceptable. Necesita mejorar al menos ${(reps * 0.3).ceil()} repeticiones más. Practique 3 series al fallo cada día y descanse 48h entre sesiones intensas.';
    } else if (nota >= 45) {
      return '⚠️ Rendimiento por debajo de lo esperado. Implemente un plan progresivo: empiece con flexiones de rodillas, agregue 2 repeticiones por semana.';
    } else {
      return '🔴 Necesita mejorar significativamente. Comience con flexiones asistidas (pared o rodillas), 3 series de 10 repeticiones diarias. Aumente gradualmente.';
    }
  }

  String _getAbsRecommendation(double nota, int reps) {
    if (nota >= 90) {
      return '🏆 ¡Excelente rendimiento abdominal! Su core es fuerte. Diversifique con planchas laterales y ejercicios de anti-rotación.';
    } else if (nota >= 75) {
      return '👍 Buen rendimiento. Para subir de nivel, agregue planchas de 60 segundos y haga series de crunch biciclo para fortalecer oblicuos.';
    } else if (nota >= 60) {
      return '📈 Rendimiento aceptable. Fortalezca el core con 3 series de plancha (30-45 seg) + 20 abdominales diarios por 4 semanas.';
    } else if (nota >= 45) {
      return '⚠️ Su core necesita refuerzo. Haga plancha acumulando tiempo (meta: 60 seg) y 3 series de crunch 15 reps diarios.';
    } else {
      return '🔴 Área crítica de mejora. Comience con plancha de rodillas 20 seg × 3, y 10 abdominales parciales. Aumente cada semana.';
    }
  }

  String _getCardioRecommendation(double nota, int totalSec) {
    if (nota >= 90) {
      return '🏆 ¡Excelente condición cardiovascular! Está en el rango superior. Mantenga su plan de entrenamiento aeróbico.';
    } else if (nota >= 75) {
      return '👍 Buena condición cardio. Para mejorar, agregue intervalos de alta intensidad (HIIT) 2 veces por semana y trote continuo 3 veces.';
    } else if (nota >= 60) {
      return '📈 Condición aceptable. Aumente la frecuencia de trote a 4x/semana. Alterne sesiones de 30 min a ritmo moderado con intervalos cortos.';
    } else if (nota >= 45) {
      return '⚠️ Necesita mejorar su resistencia. Comience con caminata rápida 20 min/día, progresando a trote ligero. Meta: reducir su tiempo actual un 10%.';
    } else {
      return '🔴 Condición cardiovascular baja. Plan de 6 semanas recomendado: Semana 1-2 caminata 20 min, Semana 3-4 alternancia caminata/trote, Semana 5-6 trote continuo.';
    }
  }
}