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

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scoringService),
        ChangeNotifierProvider(
          create: (_) => ContentProvider()..loadAllContent(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(dbService)..loadProfile(),
        ),
        ChangeNotifierProvider(
          create: (_) => PfaHistoryProvider(dbService)..loadHistory(),
        ),
        ChangeNotifierProvider(
          create: (_) => SimulatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(geminiService, dbService)..loadHistory(),
        ),
      ],
      child: const NavyPFAApp(),
    ),
  );
}

class NavyPFAApp extends StatelessWidget {
  const NavyPFAApp({super.key});

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