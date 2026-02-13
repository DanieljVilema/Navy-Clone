import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const NavyPFAApp());
}

class NavyPFAApp extends StatelessWidget {
  const NavyPFAApp({super.key});

  // Colores oficiales Navy PFA
  static const Color navyPrimary = Color(0xFF001F5B);
  static const Color navyDark = Color(0xFF00133D);
  static const Color goldAccent = Color(0xFFC5A44E);
  static const Color lightGold = Color(0xFFE8D5A0);
  static const Color surfaceWhite = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navy PFA - Armada del Ecuador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navyPrimary,
          primary: navyPrimary,
          secondary: goldAccent,
          surface: surfaceWhite,
          onPrimary: Colors.white,
          onSecondary: navyDark,
        ),
        scaffoldBackgroundColor: navyPrimary,
        textTheme: GoogleFonts.robotoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: navyDark,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldAccent,
            foregroundColor: navyDark,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.8,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: goldAccent, width: 2),
          ),
          labelStyle: GoogleFonts.roboto(color: navyPrimary),
        ),
      ),
      home: const MainScreen(),
    );
  }
}