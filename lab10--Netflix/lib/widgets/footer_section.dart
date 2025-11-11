import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final links = [
      'Preguntas frecuentes',
      'Centro de ayuda',
      'Cuenta',
      'Prensa',
      'Relaciones con inversionistas',
      'Empleo',
      'Canjear tarjetas de regalo',
      'Comprar tarjetas de regalo',
      'Formas de ver',
      'Términos de uso',
      'Privacidad',
      'Preferencias de cookies',
      'Información corporativa',
      'Contáctanos',
      'Prueba de velocidad',
      'Avisos legales',
      'Solo en Netflix',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea de contacto
          const Text(
            '¿Preguntas? Llama al 0 800 55821',
            style: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 25),

          // Lista vertical de enlaces
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: links
                .map((link) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        link,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 25),

          // Selector de idioma
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white60),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.language, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Español',
                  style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // País y nota legal
          const Text(
            'Netflix Perú',
            style: TextStyle(
              color: Colors.white54,
              fontFamily: 'Roboto',
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Esta página está protegida por Google reCAPTCHA para comprobar que no eres un robot. Más info.',
            style: TextStyle(
              color: Colors.white38,
              fontFamily: 'Roboto',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
