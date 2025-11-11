abstract class Experiencia {
  String titulo;
  String fecha;
  String lugar;

  Experiencia(this.titulo, this.fecha, this.lugar);

  void imprimirReporte();
}

class Clase extends Experiencia {
  String profesor;

  Clase(String titulo, String fecha, String lugar, this.profesor)
    : super(titulo, fecha, lugar);

  @override
  void imprimirReporte() {
    print("-- Clase: $titulo");
    print("Profesor: $profesor");
    print("Fecha: $fecha");
    print("Lugar: $lugar\n");
  }
}

class Viaje extends Experiencia {
  int duracionDias;

  Viaje(String titulo, String fecha, String lugar, this.duracionDias)
    : super(titulo, fecha, lugar);

  @override
  void imprimirReporte() {
    print("-- Viaje: $titulo");
    print("Duración: $duracionDias días");
    print("Fecha de salida: $fecha");
    print("Destino: $lugar\n");
  }
}


class Evento extends Experiencia {
  String organizador;

  Evento(String titulo, String fecha, String lugar, this.organizador)
    : super(titulo, fecha, lugar);

  @override
  void imprimirReporte() {
    print("-- Evento: $titulo");
    print("Organizador: $organizador");
    print("Fecha: $fecha");
    print("Lugar: $lugar\n");
  }
}

void generarReporte(List<Experiencia> experiencias) {
  for (var exp in experiencias) {
    exp.imprimirReporte();
  }
}

void main() {
  var clase1 = Clase(
    "Yoga para principiantes",
    "2025-09-15",
    "Centro Cultural",
    "Ana Pérez",
  );
  var viaje1 = Viaje("Aventura en Cusco", "2025-10-01", "Cusco", 5);
  var evento1 = Evento(
    "Concierto de Rock",
    "2025-11-20",
    "Estadio Nacional",
    "LiveMusic Perú",
  );

  List<Experiencia> reservas = [clase1, viaje1, evento1];

  print("=== Reporte de Experiencias ===\n");
  generarReporte(reservas);
}
