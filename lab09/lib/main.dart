import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Cartelera de Cine')),

        body: MovieList(),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies = [
    Movie(
      title: 'Película 1',

      genre: 'Acción',

      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfaMK0pbJHjde2Dt-MbDyRmt4TO6U6_YnwPw&s',
    ),

    Movie(
      title: 'Película 2',

      genre: 'Comedia',

      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6p9UFfKSDG18ofSt2h2zAX-uKyuTW1dgGWg&s',
    ),

    Movie(
      title: 'Película 3',

      genre: 'Drama',

      imageUrl: 'https://pbs.twimg.com/media/EgU31ujX0AATDVj.jpg',
    ),

    // Agrega más películas según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,

      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}

class Movie {
  final String title;

  final String genre;

  final String imageUrl;

  Movie({required this.title, required this.genre, required this.imageUrl});
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),

      child: Column(
        children: <Widget>[
          Image.network(movie.imageUrl),

          Padding(
            padding: EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Text(
                  movie.title,

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 5),

                Text(
                  movie.genre,

                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
