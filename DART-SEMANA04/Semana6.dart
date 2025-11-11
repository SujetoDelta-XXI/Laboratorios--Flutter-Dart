// Clase base: Producto genérico
class Producto {
  String nombre;
  double precio;

  Producto(this.nombre, this.precio);

  String descripcion() {
    return "Producto: $nombre | Precio: S/ $precio";
  }
}

// Subtipo: Electrónico (extiende y añade garantía)
class Electronico extends Producto {
  int garantiaMeses;

  Electronico(String nombre, double precio, this.garantiaMeses)
    : super(nombre, precio);

  @override
  String descripcion() {
    // Reutilizo la base y agrego lo nuevo
    return super.descripcion() + " | Garantía: $garantiaMeses meses";
  }
}

void main() {
  var prod1 = Producto("Silla de oficina", 350.0);
  var prod2 = Electronico("Laptop Acer Aspire", 2500.0, 24);

  print("=/= Poducto Genérico =/=");
  print(prod1.descripcion());

  print("\n=/= Producto Electrónico =/=");
  print(prod2.descripcion());
}
