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
  late TabController _tabController;

  // PFA Form
  String _selectedGender = 'Male';
  String _selectedAgeGroup = '17-19';
  String _selectedAltitude = 'Below 5000 ft';

  // BCA Form
  String _heightFt = '5ft - 6in';
  String _heightIn = '';
  String _waistFt = '27ft - 50in';
  String _waistIn = '';
  String _weight = '51lb - 600lb';

  // PFA Events
  final _pushUpsController = TextEditingController();
  final _curlUpsController = TextEditingController();
  final _cardioMinController = TextEditingController();
  final _cardioSecController = TextEditingController();
  String _selectedCardioType = 'Trote 2.4km';

  // Results
  String? _pfaResult;
  String? _pfaLevel;
  double? _bcaWaistToHeight;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _ageGroups = [
    '17-19', '20-24', '25-29', '30-34', '35-39',
    '40-44', '45-49', '50-54', '55-59', '60-64', '65+'
  ];
  final List<String> _altitudes = ['Below 5000 ft', 'Above 5000 ft'];
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
    super.dispose();
  }

  void _calculatePFA() {
    int pushUps = int.tryParse(_pushUpsController.text) ?? 0;
    int curlUps = int.tryParse(_curlUpsController.text) ?? 0;
    int cardioMin = int.tryParse(_cardioMinController.text) ?? 0;
    int cardioSec = int.tryParse(_cardioSecController.text) ?? 0;

    double pushUpScore = (pushUps / 50 * 20).clamp(0, 20);
    double curlUpScore = (curlUps / 60 * 20).clamp(0, 20);
    double totalCardioSec = (cardioMin * 60 + cardioSec).toDouble();
    double cardioScore = totalCardioSec > 0
        ? ((900 - totalCardioSec) / 900 * 60).clamp(0, 60)
        : 0;

    double totalScore = pushUpScore + curlUpScore + cardioScore;

    String level;
    if (totalScore >= 90) {
      level = 'OUTSTANDING';
    } else if (totalScore >= 75) {
      level = 'EXCELLENT';
    } else if (totalScore >= 60) {
      level = 'GOOD';
    } else if (totalScore >= 45) {
      level = 'SATISFACTORY';
    } else {
      level = 'FAILURE';
    }

    setState(() {
      _pfaResult = '${totalScore.toStringAsFixed(1)} / 100';
      _pfaLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ── TABS ──
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: NavyPFAApp.navyPrimary,
              indicatorWeight: 3,
              labelColor: NavyPFAApp.navyPrimary,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Welcome'),
                Tab(text: 'PFA Calculator'),
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
            'PFA Calculator',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This tool allows you to calculate your Physical Fitness Assessment (PFA) score based on your performance in the Body Composition Assessment (BCA) and Physical Readiness Test (PRT).',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap on "PFA Calculator" tab above to get started.',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: NavyPFAApp.navyPrimary,
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
          _buildDemographicRow(),
          const SizedBox(height: 20),

          // ── BODY COMPOSITION ASSESSMENT (BCA) ──
          _buildSectionLabel('Body Composition Assessment (BCA)'),
          const SizedBox(height: 8),
          _buildBCAForm(),
          const SizedBox(height: 8),

          // ── BCA RESULTS TABLE ──
          _buildBCAResultsTable(),
          const SizedBox(height: 20),

          // ── PHYSICAL READINESS TEST (PRT) ──
          _buildSectionLabel('Physical Readiness Test (PRT)'),
          const SizedBox(height: 8),
          _buildPRTForm(),
          const SizedBox(height: 20),

          // ── CALCULATE BUTTON ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _calculatePFA,
              style: ElevatedButton.styleFrom(
                backgroundColor: NavyPFAApp.navyPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Calculate PFA Score',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          if (_pfaResult != null) ...[
            const SizedBox(height: 16),
            _buildPFAResultCard(),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDemographicRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactDropdown(
              label: 'Sex',
              value: _selectedGender,
              items: _genders,
              onChanged: (v) => setState(() => _selectedGender = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildCompactDropdown(
              label: 'Age',
              value: _selectedAgeGroup,
              items: _ageGroups,
              onChanged: (v) => setState(() => _selectedAgeGroup = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildCompactDropdown(
              label: 'Altitude',
              value: _selectedAltitude,
              items: _altitudes,
              onChanged: (v) => setState(() => _selectedAltitude = v!),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.grey.shade600),
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
          _buildFormRow('Height', _heightFt, 'in', Icons.height,
              rightHint: 'in'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('Select a value', italic: true,
              subtext: 'Round up to the nearest half-inch'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRow('Waist', _waistFt, 'in', Icons.straighten,
              rightHint: 'in'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('Select a value', italic: true,
              subtext: 'Round down to the nearest half-inch'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRow('Weight', _weight, 'lb', Icons.monitor_weight_outlined,
              rightHint: 'lb'),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildFormRowText('', italic: false,
              subtext: 'Round to the nearest pound'),
        ],
      ),
    );
  }

  Widget _buildFormRow(
      String label, String value, String unit, IconData icon,
      {String? rightHint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          if (rightHint != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              child: Text(
                rightHint,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
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

  Widget _buildBCAResultsTable() {
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
            child: Text(
              'Body Composition Assessment Results',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Table header
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _tableHeaderCell('Step', flex: 1),
                _tableHeaderCell('Test', flex: 3),
                _tableHeaderCell('Value', flex: 2),
                _tableHeaderCell('Max', flex: 2),
                _tableHeaderCell('Result', flex: 2),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Table row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _tableCell('1', flex: 1),
                _tableCell('Waist to Height\nRatio', flex: 3),
                _tableCell('-', flex: 2),
                _tableCell('0.5500', flex: 2),
                _tableCell('-', flex: 2),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _tableCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildPRTForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Push-ups section header
          _buildPRTSectionHeader('Push-ups'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              controller: _pushUpsController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter reps',
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
          _buildPRTSectionHeader('Forearm Plank / Curl-ups'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              controller: _curlUpsController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter time (mm:ss) or reps',
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
          _buildPRTSectionHeader('Cardio Event'),
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
                      value: _selectedCardioType,
                      isExpanded: true,
                      isDense: true,
                      style: GoogleFonts.roboto(
                          fontSize: 13, color: Colors.black87),
                      items: _cardioTypes.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => _selectedCardioType = v!),
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
                          hintText: 'Sec',
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

  Widget _buildPFAResultCard() {
    Color levelColor;
    IconData levelIcon;
    switch (_pfaLevel) {
      case 'OUTSTANDING':
        levelColor = const Color(0xFF4CAF50);
        levelIcon = Icons.emoji_events_rounded;
        break;
      case 'EXCELLENT':
        levelColor = const Color(0xFF2196F3);
        levelIcon = Icons.star_rounded;
        break;
      case 'GOOD':
        levelColor = const Color(0xFF03A9F4);
        levelIcon = Icons.thumb_up_rounded;
        break;
      case 'SATISFACTORY':
        levelColor = const Color(0xFFFFC107);
        levelIcon = Icons.warning_rounded;
        break;
      default:
        levelColor = const Color(0xFFF44336);
        levelIcon = Icons.dangerous_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: levelColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: levelColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(levelIcon, size: 40, color: levelColor),
          const SizedBox(height: 10),
          Text(
            _pfaResult!,
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _pfaLevel!,
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: levelColor,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}