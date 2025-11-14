import 'package:flutter/cupertino.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("MENÚ PRINCIPAL"),
        backgroundColor: Color(0xFF000000),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menuButton(context, "HOME", "/home", CupertinoColors.activeBlue),
            menuButton(context, "PROFILE", "/register", CupertinoColors.systemPink),
            menuButton(context, "TAREAS", "/tasks", CupertinoColors.activeGreen),
          ],
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, String text, String route, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CupertinoButton(
        color: const Color(0xFF000000),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        borderRadius: BorderRadius.circular(12),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
