import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const RetroCalculatorApp());
}

class RetroCalculatorApp extends StatelessWidget {
  const RetroCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retro Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F0D), // Fondo oscuro
        primaryColor: const Color(0xFF00FFC6),            // Color neón
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.cyanAccent,
              displayColor: Colors.cyanAccent,
            ),
      ),
      home: const CalculatorScreen(),
    );
  }
}
