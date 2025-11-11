mixin Alerta {
  void enviarAlerta(String mensaje) {
    print("🚨 ALERTA: $mensaje");
  }
}

mixin Geolocalizable {
  int bateria = 100;

  void mostrarUbicacion() {
    if (bateria > 20) {
      print("📍 Mostrando ubicación en el mapa...");
    } else {
      print("❌ No se puede geolocalizar, batería insuficiente.");
    }
  }
}

class Sensor {
  String tipo;
  Sensor(this.tipo);
}

class SensorInteligente extends Sensor with Alerta, Geolocalizable {
  SensorInteligente(String tipo) : super(tipo);
}

class Lampara {
  String color;
  Lampara(this.color);
}

class LamparaSmart extends Lampara with Alerta {
  LamparaSmart(String color) : super(color);
}

class Dron {
  String modelo;
  Dron(this.modelo);
}

class DronAvanzado extends Dron with Geolocalizable {
  DronAvanzado(String modelo) : super(modelo);
}

void main() {
  var sensor = SensorInteligente("Temperatura");
  print("=== Sensor Inteligente ===");
  sensor.enviarAlerta("Temperatura alta detectada");
  sensor.mostrarUbicacion();

  var lampara = LamparaSmart("Blanca");
  print("\n=== Lámpara Smart ===");
  lampara.enviarAlerta("Bombilla fundida");

  var dron = DronAvanzado("X-500");
  print("\n=== Dron Avanzado ===");
  dron.bateria = 15;
  dron.mostrarUbicacion();
}
