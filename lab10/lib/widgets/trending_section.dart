import 'package:flutter/material.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4pcmq6bHOZ9ua9fzX-TPavdgY1c76cSHFqA&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoFnZp9dUnWle3HYvYCFJ0Ex6CMQTQ0Y8Dcg&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhU9_b53G5SBYwBeyOBVljXbwWvZPXQvwx_g&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMHZM_RxZqzNXCn1Z25Df1XkYRwERx2ELn1A&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQc5S_CUrGuaWkOGRPgB8fQe3ftj3EHetguGQ&s',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Tendencias',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 26,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(movies[index], width: 140, fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Text(
                        '${index+1}',
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
