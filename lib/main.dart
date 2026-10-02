import 'package:flutter/material.dart';
import 'core/calculator_theme.dart';
import 'views/main_calculator_view.dart';

void main() {
  runApp(const AdvCalculatorApp());
}

class AdvCalculatorApp extends StatelessWidget {
  const AdvCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CASIO fx-991ES Calculator',
      debugShowCheckedModeBanner: false,
      theme: CalculatorTheme.theme,
      home: const MainCalculatorView(),
    );
  }
}
