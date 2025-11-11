import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/register_page.dart';
import 'screens/menu_page.dart';
import 'screens/tasks_page.dart';

void main() {
  runApp(const CyberpunkApp());
}

class CyberpunkApp extends StatelessWidget {
  const CyberpunkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17), // fondo oscuro
        fontFamily: 'RobotoMono',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFFF), // cyan neon
          secondary: Color(0xFFFF00FF), // magenta neon
          background: Color(0xFF0F0E17),
          surface: Color(0xFF1A1A2E),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEEEEEE)),
          titleLarge: TextStyle(
            color: Color(0xFFFF00FF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(),
        '/tasks': (context) => const TasksPage(),
      },
    );
  }
}
