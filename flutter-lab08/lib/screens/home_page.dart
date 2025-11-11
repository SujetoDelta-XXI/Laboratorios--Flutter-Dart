import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CYBERTASK"),
        backgroundColor: Colors.black.withOpacity(0.8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/menu'),
            child: const Text("MENÚ", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
      body: Center(
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text("ENTRAR"),
          ),
        ),
      ),
    );
  }
}
