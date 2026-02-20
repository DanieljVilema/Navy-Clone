// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/main.dart';
import 'package:navy_pfa_armada_ecuador/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/providers/user_provider.dart';
import 'package:navy_pfa_armada_ecuador/providers/pfa_history_provider.dart';
import 'package:navy_pfa_armada_ecuador/providers/simulator_provider.dart';
import 'package:navy_pfa_armada_ecuador/providers/chat_provider.dart';
import 'package:navy_pfa_armada_ecuador/services/database_service.dart';
import 'package:navy_pfa_armada_ecuador/services/scoring_service.dart';
import 'package:navy_pfa_armada_ecuador/services/json_loader_service.dart';
import 'package:navy_pfa_armada_ecuador/services/gemini_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Provide mocks/dummies for providers
    final dbService = DatabaseService();
    final scoringService = ScoringService([]);
    final geminiService = GeminiService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: scoringService),
          ChangeNotifierProvider(create: (_) => ContentProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider(dbService)),
          ChangeNotifierProvider(create: (_) => PfaHistoryProvider(dbService)),
          ChangeNotifierProvider(create: (_) => SimulatorProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider(geminiService, dbService)),
        ],
        child: const NavyPFAApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Just verify the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
