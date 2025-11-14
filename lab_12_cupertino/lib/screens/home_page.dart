import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // para BoxShadow y Border

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("CYBERTASK"),
        backgroundColor: const Color(0xFF000000).withOpacity(0.8),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            "MENÚ",
            style: TextStyle(color: Color(0xFF00FFFF)),
          ),
          onPressed: () => Navigator.pushNamed(context, '/menu'),
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.pinkAccent,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            borderRadius: BorderRadius.circular(12),
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text(
              "ENTRAR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
