import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const NetflixCloneApp());
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 30),
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          labelLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
