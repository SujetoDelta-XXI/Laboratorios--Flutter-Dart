import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab03/main.dart'; // Asegúrate de que el nombre del paquete sea correcto

void main() {
  testWidgets('Pantalla principal carga correctamente', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const RetroCalculatorApp());

    // Verificar que la pantalla inicial muestra "0"
    expect(find.text('0'), findsOneWidget);
  });
}

