class Contenido {
  String titulo;
  String autor;
  int anio;

  Contenido(this.titulo, this.autor, this.anio);

  // Método para mostrar ficha (base)
  void mostrarFicha() {
    print("Título: $titulo");
    print("Autor: $autor");
    print("Año: $anio");
  }
}

class Libro extends Contenido {
  int numeroPaginas;

  Libro(String titulo, String autor, int anio, this.numeroPaginas)
      : super(titulo, autor, anio);

  @override
  void mostrarFicha() {
    super.mostrarFicha();
    print("Número de páginas: $numeroPaginas");
  }
}

class Pelicula extends Contenido {
  int duracion; 

  Pelicula(String titulo, String autor, int anio, this.duracion)
      : super(titulo, autor, anio);

  @override
  void mostrarFicha() {
    super.mostrarFicha();
    print("Duración: $duracion minutos");
  }
}

void main() {
  Libro libro1 = Libro("Cien años de soledad", "Gabriel García Márquez", 1967, 471);
  Pelicula pelicula1 = Pelicula("Inception", "Christopher Nolan", 2010, 148);

  // Mostrar fichas
  print("=== Libro ===");
  libro1.mostrarFicha();

  print("\n=== Película ===");
  pelicula1.mostrarFicha();
}