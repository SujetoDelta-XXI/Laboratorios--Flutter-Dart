import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRO DE USUARIO"),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/menu'),
            child: const Text("MENÚ", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            neonLabel("Nombre"),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent)),
              ),
            ),
            const SizedBox(height: 16),
            neonLabel("Ocupación"),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, '/menu'),
                child: const Text("CONTINUAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget neonLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.cyanAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
