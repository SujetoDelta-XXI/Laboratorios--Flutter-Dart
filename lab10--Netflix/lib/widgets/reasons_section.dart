import 'package:flutter/material.dart';

class ReasonsSection extends StatelessWidget {
  const ReasonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reasons = [
      {
        'title': 'Disfruta en tu TV',
        'desc':
            'Ve en smart TV, PlayStation, Xbox, Chromecast, Apple TV, reproductores de Blu-ray y más.',
        'icon': Icons.tv,
      },
      {
        'title': 'Descarga tus series para verlas offline',
        'desc': 'Guarda tu contenido favorito y siempre tendrás algo para ver.',
        'icon': Icons.download,
      },
      {
        'title': 'Disfruta donde quieras',
        'desc': 'Películas y series ilimitadas en tu teléfono, tablet o laptop.',
        'icon': Icons.phone_android,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Más motivos para unirte',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: reasons.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E0036), Color(0xFF150033)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    r['icon'] as IconData,
                    color: Colors.pinkAccent,
                    size: 32,
                  ),
                  title: Text(
                    r['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    r['desc'] as String,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
