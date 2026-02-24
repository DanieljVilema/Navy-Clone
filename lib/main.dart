import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'main_screen.dart';

// Services
import 'services/database_service.dart';
import 'services/json_loader_service.dart';
import 'services/scoring_service.dart';
import 'services/gemini_service.dart';

// Providers
import 'providers/content_provider.dart';
import 'providers/user_provider.dart';
import 'providers/pfa_history_provider.dart';
import 'providers/simulator_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/exercise_log_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

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
    // Pass GEMINI_API_KEY via --dart-define=GEMINI_API_KEY=your_key
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
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
