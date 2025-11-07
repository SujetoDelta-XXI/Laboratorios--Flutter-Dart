import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/retro_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  String _display = '0';
  String _operation = '';
  double _firstNumber = 0;
  double _secondNumber = 0;
  bool _waitingForOperand = false;
  bool _operationPressed = false;

  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (_waitingForOperand) {
        _display = number;
        _waitingForOperand = false;
      } else {
        _display = _display == '0' ? number : _display + number;
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (!_operationPressed) {
        _firstNumber = double.parse(_display);
        _operation = operation;
        _waitingForOperand = true;
        _operationPressed = true;
      } else {
        _calculate();
        _firstNumber = double.parse(_display);
        _operation = operation;
        _waitingForOperand = true;
      }
    });
  }

  void _calculate() {
    _secondNumber = double.parse(_display);
    double result = 0;

    switch (_operation) {
      case '+':
        result = _firstNumber + _secondNumber;
        break;
      case '-':
        result = _firstNumber - _secondNumber;
        break;
      case '×':
        result = _firstNumber * _secondNumber;
        break;
      case '÷':
        result = _secondNumber != 0 ? _firstNumber / _secondNumber : 0;
        break;
    }

    setState(() {
      _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
      _waitingForOperand = true;
      _operationPressed = false;
    });
  }

  void _onEqualsPressed() {
    if (_operation.isNotEmpty && !_waitingForOperand) {
      _calculate();
    }
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _operation = '';
      _firstNumber = 0;
      _secondNumber = 0;
      _waitingForOperand = false;
      _operationPressed = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF001122),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Display
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF001122),
                          Color(0xFF002244),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF00FFFF),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FFFF).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFFF).withOpacity(_glowAnimation.value * 0.5),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _display,
                              style: GoogleFonts.orbitron(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00FFFF),
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Buttons
                Expanded(
                  flex: 4,
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      // Row 1
                      RetroButton(
                        text: 'C',
                        onPressed: _onClearPressed,
                        color: const Color(0xFFFF4444),
                        textColor: Colors.white,
                      ),
                      RetroButton(
                        text: '⌫',
                        onPressed: _onDeletePressed,
                        color: const Color(0xFFFF8800),
                        textColor: Colors.white,
                      ),
                      RetroButton(
                        text: '÷',
                        onPressed: () => _onOperationPressed('÷'),
                        color: const Color(0xFF00FFFF),
                        textColor: Colors.black,
                      ),
                      RetroButton(
                        text: '×',
                        onPressed: () => _onOperationPressed('×'),
                        color: const Color(0xFF00FFFF),
                        textColor: Colors.black,
                      ),
                      // Row 2
                      RetroButton(
                        text: '7',
                        onPressed: () => _onNumberPressed('7'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '8',
                        onPressed: () => _onNumberPressed('8'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '9',
                        onPressed: () => _onNumberPressed('9'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '-',
                        onPressed: () => _onOperationPressed('-'),
                        color: const Color(0xFF00FFFF),
                        textColor: Colors.black,
                      ),
                      // Row 3
                      RetroButton(
                        text: '4',
                        onPressed: () => _onNumberPressed('4'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '5',
                        onPressed: () => _onNumberPressed('5'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '6',
                        onPressed: () => _onNumberPressed('6'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '+',
                        onPressed: () => _onOperationPressed('+'),
                        color: const Color(0xFF00FFFF),
                        textColor: Colors.black,
                      ),
                      // Row 4
                      RetroButton(
                        text: '1',
                        onPressed: () => _onNumberPressed('1'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '2',
                        onPressed: () => _onNumberPressed('2'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '3',
                        onPressed: () => _onNumberPressed('3'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                      RetroButton(
                        text: '=',
                        onPressed: _onEqualsPressed,
                        color: const Color(0xFF00FF00),
                        textColor: Colors.black,
                        isEquals: true,
                      ),
                      // Row 5
                      RetroButton(
                        text: '0',
                        onPressed: () => _onNumberPressed('0'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                        isZero: true,
                      ),
                      RetroButton(
                        text: '.',
                        onPressed: () => _onNumberPressed('.'),
                        color: const Color(0xFF333333),
                        textColor: const Color(0xFF00FFFF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
