import 'package:flutter/material.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      '¿Qué es Netflix?',
      '¿Cuánto cuesta Netflix?',
      '¿Dónde puedo ver Netflix?',
      '¿Cómo cancelo?',
      '¿Qué puedo ver en Netflix?',
      '¿Es bueno Netflix para los niños?',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preguntas frecuentes',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: faqs.map((q) {
              return ExpansionTile(
                collapsedBackgroundColor: Colors.grey.shade900,
                backgroundColor: Colors.grey.shade800,
                title: Text(q, style: const TextStyle(fontFamily: 'Montserrat')),
                textColor: Colors.white,
                iconColor: Colors.white,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Aquí iría la respuesta a "$q".',
                      style: const TextStyle(fontFamily: 'Roboto', color: Colors.white70),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
