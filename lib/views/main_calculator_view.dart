import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/calculator_theme.dart';
import '../core/math_parser.dart';
import '../models/calculator_mode.dart';
import 'display.dart';
import 'scientific_view.dart';
import 'equation_solver_view.dart';
import 'matrix_view.dart';
import 'history_saved_view.dart';
import 'api_modal.dart';

class MainCalculatorView extends StatefulWidget {
  const MainCalculatorView({super.key});

  @override
  State<MainCalculatorView> createState() => _MainCalculatorViewState();
}

class _MainCalculatorViewState extends State<MainCalculatorView> {
  CalculatorMode _currentMode = CalculatorMode.scientific;
  String _expression = '';
  String _result = '';
  AngleUnit _angleUnit = AngleUnit.deg;
  final bool _isHyp = false;
  bool _isShift = false;
  bool _isAlpha = false;
  double? _lastAns;

  final List<String> _historyTape = [];
  final List<String> _historyLog = [];
  final List<String> _savedFormulas = [
    'sin(30) + cos(60)',
    'sqrt(3^2 + 4^2)',
    'log(100) * ln(e)',
  ];
  final List<String> _undoStack = [];

  void _pushUndo() {
    _undoStack.add(_expression);
    if (_undoStack.length > 20) _undoStack.removeAt(0);
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      HapticFeedback.mediumImpact();
      setState(() {
        _expression = _undoStack.removeLast();
      });
    }
  }

  void _onButtonPressed(String label) {
    if (label != 'SHIFT' && label != 'ALPHA' && label != 'DEG/RAD') {
      _pushUndo();
    }

    setState(() {
      if (label == 'AC') {
        _expression = '';
        _result = '';
      } else if (label == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (label == '=') {
        if (_expression.isNotEmpty) {
          _result = MathParser.evaluate(_expression, _angleUnit, ans: _lastAns);
          if (!_result.contains('Error')) {
            double? parsedVal = double.tryParse(_result);
            if (parsedVal != null) {
              _lastAns = parsedVal;
            }
            _historyTape.insert(0, '$_expression = $_result');
            _historyLog.insert(0, '$_expression = $_result');
            if (_historyTape.length > 5) _historyTape.removeLast();
          }
        }
      } else if (label == 'DEG/RAD') {
        _angleUnit = _angleUnit == AngleUnit.deg ? AngleUnit.rad : AngleUnit.deg;
      } else if (label == 'SHIFT') {
        _isShift = !_isShift;
      } else if (label == 'ALPHA') {
        _isAlpha = !_isAlpha;
      } else if (label == 'MODE') {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ApiModal(expression: _expression, result: _result),
        );
      } else {
        if (_result.isNotEmpty && !_result.contains('Error') && _expression.isEmpty) {
          _expression = label;
          _result = '';
        } else {
          _expression += label;
        }
      }
    });
  }

  void _openHistoryModal() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: HistorySavedView(
            history: _historyLog,
            savedFormulas: _savedFormulas,
            onSelectFormula: (formula) {
              setState(() {
                _expression = formula;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: CalculatorTheme.background),
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CalculatorTheme.indigoGlow.withValues(alpha: 0.25),
                boxShadow: [
                  BoxShadow(
                    color: CalculatorTheme.indigoGlow.withValues(alpha: 0.25),
                    blurRadius: 150,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CalculatorTheme.violetGlow.withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: CalculatorTheme.violetGlow.withValues(alpha: 0.3),
                    blurRadius: 160,
                    spreadRadius: 90,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: CalculatorTheme.equalsGradient),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: CalculatorTheme.scientificText.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.bolt_rounded, color: Colors.black, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'OMNI_CALC',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.hub, color: CalculatorTheme.scientificText),
                        tooltip: 'Math API & LaTeX',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ApiModal(expression: _expression, result: _result),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Mode Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: CalculatorTheme.glassSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CalculatorTheme.glassBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildTabButton('Scientific', CalculatorMode.scientific, Icons.science)),
                      Expanded(child: _buildTabButton('Equations', CalculatorMode.equationSolver, Icons.functions)),
                      Expanded(child: _buildTabButton('Matrix', CalculatorMode.matrix, Icons.grid_on)),
                    ],
                  ),
                ),
                // Calculator Display Panel
                CalculatorDisplay(
                  expression: _expression,
                  result: _result,
                  angleUnit: _angleUnit,
                  isHyp: _isHyp,
                  historyTape: _historyTape,
                  onSwipeRight: _openHistoryModal,
                  onSwipeLeft: _undo,
                ),
                // Main Content View (Scientific Grid / Equation Solver / Matrix View)
                Expanded(
                  child: _buildCurrentView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, CalculatorMode mode, IconData icon) {
    bool isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentMode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CalculatorTheme.keyScientific : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: CalculatorTheme.glassBorder) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CalculatorTheme.scientificText.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? CalculatorTheme.scientificText : CalculatorTheme.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : CalculatorTheme.textMuted,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentMode) {
      case CalculatorMode.scientific:
        return ScientificView(
          expression: _expression,
          result: _result,
          angleUnit: _angleUnit,
          isShift: _isShift,
          isAlpha: _isAlpha,
          onButtonPressed: _onButtonPressed,
        );
      case CalculatorMode.equationSolver:
        return const EquationSolverView();
      case CalculatorMode.matrix:
        return const MatrixView();
    }
  }
}
