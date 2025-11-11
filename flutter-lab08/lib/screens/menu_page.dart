import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MENÚ PRINCIPAL"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menuButton(context, "HOME", "/home", Colors.cyanAccent),
            menuButton(context, "PROFILE", "/register", Colors.pinkAccent),
            menuButton(context, "TAREAS", "/tasks", Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, String text, String route, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          side: BorderSide(color: color, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
