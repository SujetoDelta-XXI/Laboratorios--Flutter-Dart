import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const RetroCalculatorApp());
}

class RetroCalculatorApp extends StatelessWidget {
  const RetroCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        textTheme: GoogleFonts.orbitronTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFFF),
          secondary: Color(0xFFFF00FF),
          surface: Color(0xFF0A0A0A),
          background: Color(0xFF000000),
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFF000000),
          onSurface: Color(0xFF00FFFF),
          onBackground: Color(0xFF00FFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const CalculatorScreen(),
    );
  }
}
