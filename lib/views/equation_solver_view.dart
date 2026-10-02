import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/calculator_theme.dart';
import '../models/equation_model.dart';

class EquationSolverView extends StatefulWidget {
  const EquationSolverView({super.key});

  @override
  State<EquationSolverView> createState() => _EquationSolverViewState();
}

class _EquationSolverViewState extends State<EquationSolverView> {
  int _equationType = 0; // 0: Quadratic (ax^2+bx+c=0), 1: Simultaneous 2x2

  final TextEditingController _aCtrl = TextEditingController(text: '1');
  final TextEditingController _bCtrl = TextEditingController(text: '-3');
  final TextEditingController _cCtrl = TextEditingController(text: '2');

  final TextEditingController _a2Ctrl = TextEditingController(text: '1');
  final TextEditingController _b2Ctrl = TextEditingController(text: '1');
  final TextEditingController _c2Ctrl = TextEditingController(text: '5');

  List<String> _solutions = [];

  void _solve() {
    HapticFeedback.lightImpact();
    setState(() {
      try {
        if (_equationType == 0) {
          double a = double.parse(_aCtrl.text);
          double b = double.parse(_bCtrl.text);
          double c = double.parse(_cCtrl.text);
          _solutions = EquationModel.solveQuadratic(a, b, c);
        } else {
          double a1 = double.parse(_aCtrl.text);
          double b1 = double.parse(_bCtrl.text);
          double c1 = double.parse(_cCtrl.text);
          double a2 = double.parse(_a2Ctrl.text);
          double b2 = double.parse(_b2Ctrl.text);
          double c2 = double.parse(_c2Ctrl.text);
          _solutions = EquationModel.solveSimultaneous2x2(a1, b1, c1, a2, b2, c2);
        }
      } catch (e) {
        _solutions = ['Invalid Input Error'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildChoiceChip('Quadratic (ax²+bx+c=0)', 0)),
              const SizedBox(width: 12),
              Expanded(child: _buildChoiceChip('Simultaneous 2×2', 1)),
            ],
          ),
          const SizedBox(height: 24),
          if (_equationType == 0) ...[
            const Text('Enter Coefficients (a, b, c):', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_aCtrl, 'a')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_bCtrl, 'b')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_cCtrl, 'c')),
              ],
            ),
          ] else ...[
            const Text('Equation 1: a₁x + b₁y = c₁', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField(_aCtrl, 'a₁')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_bCtrl, 'b₁')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_cCtrl, 'c₁')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Equation 2: a₂x + b₂y = c₂', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField(_a2Ctrl, 'a₂')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_b2Ctrl, 'b₂')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_c2Ctrl, 'c₂')),
              ],
            ),
          ],
          const SizedBox(height: 28),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: CalculatorTheme.equalsGradient),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: CalculatorTheme.scientificText.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _solve,
              child: const Text('SOLVE EQUATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          const SizedBox(height: 28),
          const Text('Solutions:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CalculatorTheme.textMuted)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CalculatorTheme.glassSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CalculatorTheme.glassBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _solutions.isEmpty
                      ? [const Text('No solution computed yet.', style: TextStyle(color: CalculatorTheme.textMuted))]
                      : _solutions.map((s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                          )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, int type) {
    bool selected = _equationType == type;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _equationType = type;
          _solutions.clear();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? CalculatorTheme.keyScientific : CalculatorTheme.glassSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? CalculatorTheme.glassBorder : CalculatorTheme.glassBorder.withValues(alpha: 0.3)),
          boxShadow: selected
              ? [BoxShadow(color: CalculatorTheme.scientificText.withValues(alpha: 0.2), blurRadius: 8)]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? CalculatorTheme.scientificText : CalculatorTheme.textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: CalculatorTheme.textMuted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CalculatorTheme.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CalculatorTheme.scientificText, width: 2),
        ),
        filled: true,
        fillColor: CalculatorTheme.keyBase,
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
    );
  }
}
