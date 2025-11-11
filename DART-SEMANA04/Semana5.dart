abstract class Orden {
  void ejecutar();
}

class OrdenCompra implements Orden {
  @override
  void ejecutar() {
    print("🛒 Ejecutando orden de COMPRA...");
  }
}

class OrdenVenta implements Orden {
  @override
  void ejecutar() {
    print("💰 Ejecutando orden de VENTA...");
  }
}

class OrdenDevolucion implements Orden {
  @override
  void ejecutar() {
    print("↩️ Ejecutando orden de DEVOLUCIÓN...");
  }
}

class GestorOrdenes {
  List<Orden> _ordenes = [];

  void agregar(Orden orden) {
    _ordenes.add(orden);
    print("✅ Orden agregada");
  }

  void quitar(Orden orden) {
    _ordenes.remove(orden);
    print("❌ Orden eliminada");
  }

  void procesarTodas() {
    print("\n=== Procesando todas las órdenes ===");
    for (var orden in _ordenes) {
      orden.ejecutar();
    }
  }
}

void main() {
  var gestor = GestorOrdenes();

  var compra = OrdenCompra();
  var venta = OrdenVenta();
  var devolucion = OrdenDevolucion();

  gestor.agregar(compra);
  gestor.agregar(venta);
  gestor.agregar(devolucion);

  gestor.procesarTodas();

  // Quitar una orden
  gestor.quitar(venta);

  gestor.procesarTodas();
}