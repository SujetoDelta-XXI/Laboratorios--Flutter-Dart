abstract class MetodoPago {
  void validar();
  void procesar();
  void confirmar();

  void ejecutarPago() {
    validar();
    procesar();
    confirmar();
    print("Pago completado ✅\n");
  }
}

class PagoTarjeta extends MetodoPago {
  @override
  void validar() {
    print("Validando tarjeta... ✅");
  }

  @override
  void procesar() {
    print("Procesando cobro a la tarjeta... 💳");
    print("Solicitando PIN de seguridad... 🔐");
  }

  @override
  void confirmar() {
    print("Confirmando transacción con el banco... 🏦");
  }
}

class PagoPayPal extends MetodoPago {
  @override
  void validar() {
    print("Validando cuenta PayPal... ✅");
  }

  @override
  void procesar() {
    print("Procesando cobro en PayPal... 🌐");
  }

  @override
  void confirmar() {
    print("Confirmación enviada por correo electrónico... 📧");
  }
}

void main() {
  MetodoPago pago1 = PagoTarjeta();
  MetodoPago pago2 = PagoPayPal();

  print("=== Pago con Tarjeta ===");
  pago1.ejecutarPago();

  print("=== Pago con PayPal ===");
  pago2.ejecutarPago();
}
  