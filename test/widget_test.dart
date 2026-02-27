import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/main.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/user_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/performance/providers/pfa_history_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/simulator/providers/simulator_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/providers/chat_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/database_service.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/scoring_service.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/services/gemini_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final dbService = DatabaseService();
    final scoringService = ScoringService([]);
    final geminiService = GeminiService();
    final contentProvider = ContentProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: scoringService),
          Provider.value(value: geminiService),
          ChangeNotifierProvider.value(value: contentProvider),
          ChangeNotifierProvider(create: (_) => UserProvider(dbService)),
          ChangeNotifierProvider(create: (_) => PfaHistoryProvider(dbService)),
          ChangeNotifierProvider(create: (_) => SimulatorProvider()),
          ChangeNotifierProvider(
              create: (_) => ChatProvider(geminiService, dbService)),
        ],
        child: NavyPFAApp(
          contentProvider: contentProvider,
          geminiService: geminiService,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
