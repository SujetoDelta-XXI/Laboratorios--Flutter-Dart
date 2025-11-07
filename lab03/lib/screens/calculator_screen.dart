import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/retro_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String operand = '';
  double firstNum = 0;
  double secondNum = 0;

  void numClick(String value) {
    setState(() {
      if (display == '0') {
        display = value;
      } else {
        display += value;
      }
    });
  }

  void clear() {
    setState(() {
      display = '0';
      firstNum = 0;
      secondNum = 0;
      operand = '';
    });
  }

  void setOperator(String op) {
    setState(() {
      firstNum = double.tryParse(display) ?? 0;
      operand = op;
      display = '0';
    });
  }

  void calculate() {
    setState(() {
      secondNum = double.tryParse(display) ?? 0;
      double result = 0;
      switch (operand) {
        case '+':
          result = firstNum + secondNum;
          break;
        case '-':
          result = firstNum - secondNum;
          break;
        case '×':
          result = firstNum * secondNum;
          break;
        case '÷':
          result = secondNum != 0 ? firstNum / secondNum : 0;
          break;
      }
      display = result.toString();
      operand = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = GoogleFonts.orbitron(
      textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 248, 248, 248),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Pantalla
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF001F1F), Color(0xFF0A0F0D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  display,
                  style: GoogleFonts.orbitron(
                    fontSize: 48,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Botones
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF121212),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    RetroButton('7', onTap: () => numClick('7'), style: buttonStyle),
                    RetroButton('8', onTap: () => numClick('8'), style: buttonStyle),
                    RetroButton('9', onTap: () => numClick('9'), style: buttonStyle),
                    RetroButton('÷', onTap: () => setOperator('÷'), style: buttonStyle, color: Colors.pinkAccent),

                    RetroButton('4', onTap: () => numClick('4'), style: buttonStyle),
                    RetroButton('5', onTap: () => numClick('5'), style: buttonStyle),
                    RetroButton('6', onTap: () => numClick('6'), style: buttonStyle),
                    RetroButton('×', onTap: () => setOperator('×'), style: buttonStyle, color: Colors.purpleAccent),

                    RetroButton('1', onTap: () => numClick('1'), style: buttonStyle),
                    RetroButton('2', onTap: () => numClick('2'), style: buttonStyle),
                    RetroButton('3', onTap: () => numClick('3'), style: buttonStyle),
                    RetroButton('-', onTap: () => setOperator('-'), style: buttonStyle, color: Colors.orangeAccent),

                    RetroButton('C', onTap: clear, style: buttonStyle, color: Colors.redAccent),
                    RetroButton('0', onTap: () => numClick('0'), style: buttonStyle),
                    RetroButton('=', onTap: calculate, style: buttonStyle, color: Colors.greenAccent),
                    RetroButton('+', onTap: () => setOperator('+'), style: buttonStyle, color: Colors.lightBlueAccent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
