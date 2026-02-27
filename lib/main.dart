import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:navy_pfa_armada_ecuador/core/theme/theme.dart';
import 'package:navy_pfa_armada_ecuador/core/routing/main_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

// Services
import 'package:navy_pfa_armada_ecuador/shared/services/database_service.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/json_loader_service.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/scoring_service.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/services/gemini_service.dart';

// Providers
import 'package:navy_pfa_armada_ecuador/shared/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/user_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/performance/providers/pfa_history_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/simulator/providers/simulator_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/providers/chat_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/providers/exercise_log_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables securely
  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize Services
  final dbService = DatabaseService();
  final baremos = await JsonLoaderService.loadBaremos();
  final scoringService = ScoringService(baremos);
  final geminiService = GeminiService();

  // Pre-load content so we can pass context to Gemini
  final contentProvider = ContentProvider();
  await contentProvider.loadAllContent();

  // Load the main COGMAR PDF bytes for Gemini multimodal
  Uint8List? cogmarPdfBytes;
  if (contentProvider.pdfPathsForGemini.isNotEmpty) {
    try {
      final byteData =
          await rootBundle.load(contentProvider.pdfPathsForGemini.first);
      cogmarPdfBytes = byteData.buffer.asUint8List();
    } catch (_) {
      // PDF not available, Gemini will work without it
    }
  }

  final chatProvider = ChatProvider(geminiService, dbService);
  chatProvider.loadHistory();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scoringService),
        Provider.value(value: geminiService),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider(
          create: (_) => UserProvider(dbService)..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => PfaHistoryProvider(dbService)..loadHistory(),
        ),
        ChangeNotifierProvider(
          create: (_) => SimulatorProvider(),
        ),
        ChangeNotifierProvider.value(value: chatProvider),
        ChangeNotifierProvider(
          create: (_) => ExerciseLogProvider(dbService)..loadExerciseTypes(),
        ),
      ],
      child: NavyPFAApp(
        contentProvider: contentProvider,
        geminiService: geminiService,
        cogmarPdfBytes: cogmarPdfBytes,
      ),
    ),
  );
}

class NavyPFAApp extends StatefulWidget {
  final ContentProvider contentProvider;
  final GeminiService geminiService;
  final Uint8List? cogmarPdfBytes;

  const NavyPFAApp({
    super.key,
    required this.contentProvider,
    required this.geminiService,
    this.cogmarPdfBytes,
  });

  @override
  State<NavyPFAApp> createState() => _NavyPFAAppState();
}

class _NavyPFAAppState extends State<NavyPFAApp> {
  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isNotEmpty) {
      await widget.geminiService.initialize(
        apiKey,
        baremosContext: widget.contentProvider.baremosContext,
        nutritionContext: widget.contentProvider.nutritionContext,
        regulationsContext: widget.contentProvider.regulationsContext,
        pdfBytes: widget.cogmarPdfBytes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluación Física Armada Ecuador',
      debugShowCheckedModeBanner: false,
      theme: buildNavyTheme(),
      home: const MainScreen(),
    );
  }
}
