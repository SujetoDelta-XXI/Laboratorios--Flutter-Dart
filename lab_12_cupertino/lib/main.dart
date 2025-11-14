import 'package:flutter/cupertino.dart';
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
    return CupertinoApp(
      title: 'CyberTask',
      debugShowCheckedModeBanner: false,

      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF00FFFF),
        scaffoldBackgroundColor: Color(0xFF0F0E17),

        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            inherit: false,                   
            color: Color(0xFFEEEEEE),
            fontFamily: 'RobotoMono',
          ),

          navTitleTextStyle: TextStyle(
            inherit: false,                   
            color: Color(0xFFFF00FF),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),

          navLargeTitleTextStyle: TextStyle(
            inherit: false,                  
            color: Color(0xFFFF00FF),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      initialRoute: '/home',
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(),
        '/tasks': (context) => const TasksPage(),
      },
    );
  }
}
