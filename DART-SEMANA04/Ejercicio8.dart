abstract class Persona {
  String nombre;
  Persona(this.nombre);

  void actividad();
}

class Alumno extends Persona {
  Alumno(String nombre) : super(nombre);

  @override
  void actividad() {
    print("$nombre está estudiando.");
  }
}

class Profesor extends Persona {
  Profesor(String nombre) : super(nombre);

  @override
  void actividad() {
    print("$nombre está enseñando.");
  }
}

mixin Reportable {
  String generarReporte() => "Reporte generado.";
}

mixin Asistible {
  void marcarAsistencia() {
    print("Asistencia registrada.");
  }
}

class GestorAcademico {
  final List<Persona> personas = [];

  void agregar(Persona p) => personas.add(p);

  void ejecutarActividades() {
    for (var p in personas) {
      p.actividad();
    }
  }

  void generarReportes() {
    for (var p in personas) {
      if (p is Reportable) {
        print("${p.nombre}: ${(p as Reportable).generarReporte()}");
      } else {
        print("${p.nombre}: No tiene reporte disponible.");
      }
    }
  }
}

class AlumnoConAsistencia extends Alumno with Asistible, Reportable {
  AlumnoConAsistencia(String nombre) : super(nombre);
}

class ProfesorInvestigador extends Profesor with Reportable {
  ProfesorInvestigador(String nombre) : super(nombre);

  @override
  void actividad() {
    print("$nombre está enseñando e investigando.");
  }
}

void main() {
  var gestor = GestorAcademico();

  var alumno = AlumnoConAsistencia("Ana");
  var profesor = Profesor("Carlos");
  var investigador = ProfesorInvestigador("Lucía");

  gestor.agregar(alumno);
  gestor.agregar(profesor);
  gestor.agregar(investigador);

  print("== Actividades ==");
  gestor.ejecutarActividades();

  print("\n== Reportes ==");
  gestor.generarReportes();

  print("\n== Acciones específicas ==");
  alumno.marcarAsistencia();
}
