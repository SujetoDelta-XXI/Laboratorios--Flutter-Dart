mixin MixinA {
  void info() {
    print("Info desde MixinA");
  }
}

mixin MixinB {
  void info() {
    print("Info desde MixinB");
  }
}

class MiClase with MixinA, MixinB {
  @override
  void info() {
    print("Info final desde MiClase (resolviendo el choque)");
  }
}

void main() {
  var objeto = MiClase();
  objeto.info(); // Se ejecuta el método final
}
