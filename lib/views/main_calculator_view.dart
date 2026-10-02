import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/calculator_theme.dart';
import '../core/math_parser.dart';
import '../models/calculator_mode.dart';
import '../services/storage_service.dart';
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
  bool _isSto = false;
  bool _isRcl = false;
  double? _lastAns;

  Map<String, double> _memoryRegisters = {
    'A': 0.0,
    'B': 0.0,
    'C': 0.0,
    'D': 0.0,
    'X': 0.0,
    'Y': 0.0,
    'Ans': 0.0,
  };

  List<String> _historyTape = [];
  List<String> _historyLog = [];
  List<String> _savedFormulas = [];
  final List<String> _undoStack = [];

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    final history = await StorageService.loadHistory();
    final formulas = await StorageService.loadSavedFormulas();
    final registers = await StorageService.loadRegisters();
    final angleUnitStr = await StorageService.loadAngleUnit();

    setState(() {
      _historyLog = history;
      _historyTape = List.from(history.take(5));
      _savedFormulas = formulas;
      _memoryRegisters = registers;
      _angleUnit = angleUnitStr == 'rad' ? AngleUnit.rad : AngleUnit.deg;
      _lastAns = registers['Ans'];
    });
  }

  void _pushUndo() {
    _undoStack.add(_expression);
    if (_undoStack.length > 25) _undoStack.removeAt(0);
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      HapticFeedback.mediumImpact();
      setState(() {
        _expression = _undoStack.removeLast();
      });
    } else if (_expression.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
      });
    }
  }

  void _onButtonPressed(String label) {
    if (label != 'SHIFT' && label != 'ALPHA' && label != 'DEG/RAD' && label != 'STO' && label != 'RCL') {
      _pushUndo();
    }

    // Handle STO mode
    if (_isSto) {
      if (['A', 'B', 'C', 'D', 'X', 'Y'].contains(label)) {
        double valToStore = 0.0;
        if (_result.isNotEmpty && !_result.contains('Error')) {
          valToStore = double.tryParse(_result) ?? 0.0;
        } else if (_expression.isNotEmpty) {
          final eval = MathParser.evaluate(_expression, _angleUnit, ans: _lastAns, registers: _memoryRegisters);
          valToStore = double.tryParse(eval) ?? 0.0;
        }
        setState(() {
          _memoryRegisters[label] = valToStore;
          _isSto = false;
          _isShift = false;
        });
        StorageService.saveRegisters(_memoryRegisters);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stored ${valToStore.toStringAsFixed(4)} in variable $label'),
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }
    }

    // Handle RCL mode
    if (_isRcl) {
      if (['A', 'B', 'C', 'D', 'X', 'Y'].contains(label)) {
        double val = _memoryRegisters[label] ?? 0.0;
        setState(() {
          _expression += val == val.toInt() ? val.toInt().toString() : val.toString();
          _isRcl = false;
          _isShift = false;
        });
        return;
      }
    }

    setState(() {
      if (label == 'AC') {
        _expression = '';
        _result = '';
        _isShift = false;
        _isAlpha = false;
        _isSto = false;
        _isRcl = false;
      } else if (label == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (label == '=') {
        if (_expression.isNotEmpty) {
          _result = MathParser.evaluate(
            _expression,
            _angleUnit,
            ans: _lastAns,
            registers: _memoryRegisters,
          );
          if (!_result.contains('Error')) {
            double? parsedVal = double.tryParse(_result);
            if (parsedVal != null) {
              _lastAns = parsedVal;
              _memoryRegisters['Ans'] = parsedVal;
              StorageService.saveRegisters(_memoryRegisters);
            }
            final entry = '$_expression = $_result';
            _historyTape.insert(0, entry);
            _historyLog.insert(0, entry);
            if (_historyTape.length > 5) _historyTape.removeLast();
            StorageService.saveHistory(_historyLog);
          }
        }
      } else if (label == 'DEG/RAD') {
        _angleUnit = _angleUnit == AngleUnit.deg ? AngleUnit.rad : AngleUnit.deg;
        StorageService.saveAngleUnit(_angleUnit == AngleUnit.rad ? 'rad' : 'deg');
      } else if (label == 'SHIFT') {
        _isShift = !_isShift;
        _isAlpha = false;
      } else if (label == 'ALPHA') {
        _isAlpha = !_isAlpha;
        _isShift = false;
      } else if (label == 'STO') {
        _isSto = !_isSto;
        _isRcl = false;
      } else if (label == 'RCL') {
        _isRcl = !_isRcl;
        _isSto = false;
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
        _isShift = false;
        _isAlpha = false;
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
        heightFactor: 0.80,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: HistorySavedView(
            history: _historyLog,
            savedFormulas: _savedFormulas,
            memoryRegisters: _memoryRegisters,
            onSelectFormula: (formula) {
              setState(() {
                _expression = formula;
              });
            },
            onClearHistory: () {
              setState(() {
                _historyLog.clear();
                _historyTape.clear();
              });
              StorageService.saveHistory([]);
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
                // Calculator Display Panel with dynamic mode glow
                CalculatorDisplay(
                  expression: _expression,
                  result: _result,
                  angleUnit: _angleUnit,
                  isHyp: _isHyp,
                  isShift: _isShift,
                  isAlpha: _isAlpha,
                  isSto: _isSto,
                  isRcl: _isRcl,
                  historyTape: _historyTape,
                  onSwipeRight: _openHistoryModal,
                  onSwipeLeft: _undo,
                ),
                // Main Content View
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
          isSto: _isSto,
          isRcl: _isRcl,
          memoryRegisters: _memoryRegisters,
          onButtonPressed: _onButtonPressed,
        );
      case CalculatorMode.equationSolver:
        return const EquationSolverView();
      case CalculatorMode.matrix:
        return const MatrixView();
    }
  }
}
