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
  static const Color navyAppBar = Color(0xFF1B2A4A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluación Física Armada Ecuador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navyPrimary,
          primary: navyPrimary,
          secondary: goldAccent,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: navyDark,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.robotoTextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: navyAppBar,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 2,
          shadowColor: Colors.black26,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: navyPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: navyPrimary, width: 2),
          ),
          labelStyle: GoogleFonts.roboto(color: Colors.grey.shade600),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 1,
          space: 0,
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          iconColor: Colors.grey.shade600,
        ),
      ),
      home: const MainScreen(),
    );
  }
}