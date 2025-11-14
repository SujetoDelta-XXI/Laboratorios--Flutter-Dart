import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // necesario para borders neon

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("REGISTRO DE USUARIO"),
        backgroundColor: const Color(0xFF000000),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            "MENÚ",
            style: TextStyle(color: Color(0xFF00FFFF)),
          ),
          onPressed: () => Navigator.pushNamed(context, '/menu'),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              neonLabel("Nombre"),
              const SizedBox(height: 8),

              // CAMPO NOMBRE
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const CupertinoTextField(
                  placeholder: "Ingresa tu nombre",
                  placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
                  style: TextStyle(color: CupertinoColors.white),
                  cursorColor: CupertinoColors.activeBlue,
                  decoration: null,
                ),
              ),

              const SizedBox(height: 16),
              neonLabel("Ocupación"),
              const SizedBox(height: 8),

              // CAMPO OCUPACIÓN
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const CupertinoTextField(
                  placeholder: "¿A qué te dedicas?",
                  placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
                  style: TextStyle(color: CupertinoColors.white),
                  cursorColor: CupertinoColors.systemPink,
                  decoration: null,
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: CupertinoButton(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  onPressed: () => Navigator.pushNamed(context, '/menu'),
                  child: const Text(
                    "CONTINUAR",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
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
        fontSize: 16,
      ),
    );
  }
}
