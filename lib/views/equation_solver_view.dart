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
  int _equationType = 0; // 0: Quadratic, 1: Simultaneous 2x2, 2: Simultaneous 3x3

  // Row 1
  final TextEditingController _aCtrl = TextEditingController(text: '1');
  final TextEditingController _bCtrl = TextEditingController(text: '-3');
  final TextEditingController _cCtrl = TextEditingController(text: '2');
  final TextEditingController _dCtrl = TextEditingController(text: '0');

  // Row 2
  final TextEditingController _a2Ctrl = TextEditingController(text: '1');
  final TextEditingController _b2Ctrl = TextEditingController(text: '1');
  final TextEditingController _c2Ctrl = TextEditingController(text: '5');
  final TextEditingController _d2Ctrl = TextEditingController(text: '0');

  // Row 3
  final TextEditingController _a3Ctrl = TextEditingController(text: '2');
  final TextEditingController _b3Ctrl = TextEditingController(text: '-1');
  final TextEditingController _c3Ctrl = TextEditingController(text: '1');
  final TextEditingController _d3Ctrl = TextEditingController(text: '3');

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
        } else if (_equationType == 1) {
          double a1 = double.parse(_aCtrl.text);
          double b1 = double.parse(_bCtrl.text);
          double c1 = double.parse(_cCtrl.text);
          double a2 = double.parse(_a2Ctrl.text);
          double b2 = double.parse(_b2Ctrl.text);
          double c2 = double.parse(_c2Ctrl.text);
          _solutions = EquationModel.solveSimultaneous2x2(a1, b1, c1, a2, b2, c2);
        } else {
          double a1 = double.parse(_aCtrl.text);
          double b1 = double.parse(_bCtrl.text);
          double c1 = double.parse(_cCtrl.text);
          double d1 = double.parse(_dCtrl.text);

          double a2 = double.parse(_a2Ctrl.text);
          double b2 = double.parse(_b2Ctrl.text);
          double c2 = double.parse(_c2Ctrl.text);
          double d2 = double.parse(_d2Ctrl.text);

          double a3 = double.parse(_a3Ctrl.text);
          double b3 = double.parse(_b3Ctrl.text);
          double c3 = double.parse(_c3Ctrl.text);
          double d3 = double.parse(_d3Ctrl.text);

          _solutions = EquationModel.solveSimultaneous3x3(
            a1, b1, c1, d1,
            a2, b2, c2, d2,
            a3, b3, c3, d3,
          );
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
          // Selector Chips
          Row(
            children: [
              Expanded(child: _buildChoiceChip('Quadratic', 0)),
              const SizedBox(width: 8),
              Expanded(child: _buildChoiceChip('Linear 2×2', 1)),
              const SizedBox(width: 8),
              Expanded(child: _buildChoiceChip('Linear 3×3', 2)),
            ],
          ),
          const SizedBox(height: 20),

          // Inputs
          if (_equationType == 0) ...[
            const Text('Quadratic Equation: ax² + bx + c = 0', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
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
          ] else if (_equationType == 1) ...[
            const Text('Linear 2×2 System: a₁x + b₁y = c₁', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
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
            const SizedBox(height: 12),
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
          ] else ...[
            const Text('Linear 3×3 System: a₁x + b₁y + c₁z = d₁', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField(_aCtrl, 'a₁')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_bCtrl, 'b₁')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_cCtrl, 'c₁')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_dCtrl, 'd₁')),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Equation 2: a₂x + b₂y + c₂z = d₂', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField(_a2Ctrl, 'a₂')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_b2Ctrl, 'b₂')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_c2Ctrl, 'c₂')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_d2Ctrl, 'd₂')),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Equation 3: a₃x + b₃y + c₃z = d₃', style: TextStyle(fontWeight: FontWeight.bold, color: CalculatorTheme.scientificText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField(_a3Ctrl, 'a₃')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_b3Ctrl, 'b₃')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_c3Ctrl, 'c₃')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_d3Ctrl, 'd₃')),
              ],
            ),
          ],

          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
        labelStyle: const TextStyle(color: CalculatorTheme.textMuted, fontSize: 12),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14),
    );
  }
}
