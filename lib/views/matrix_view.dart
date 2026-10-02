import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/calculator_theme.dart';
import '../models/matrix_model.dart';

class MatrixView extends StatefulWidget {
  const MatrixView({super.key});

  @override
  State<MatrixView> createState() => _MatrixViewState();
}

class _MatrixViewState extends State<MatrixView> {
  int _rowsA = 2;
  int _colsA = 2;
  int _rowsB = 2;
  int _colsB = 2;

  late MatrixModel matrixA = MatrixModel(2, 2, [[1, 2], [3, 4]]);
  late MatrixModel matrixB = MatrixModel(2, 2, [[5, 6], [7, 8]]);
  MatrixModel? resultMatrix;
  String scalarResult = '';

  void _resizeMatrixA(int r, int c) {
    HapticFeedback.lightImpact();
    setState(() {
      _rowsA = r;
      _colsA = c;
      matrixA = MatrixModel(r, c);
      resultMatrix = null;
      scalarResult = '';
    });
  }

  void _resizeMatrixB(int r, int c) {
    HapticFeedback.lightImpact();
    setState(() {
      _rowsB = r;
      _colsB = c;
      matrixB = MatrixModel(r, c);
      resultMatrix = null;
      scalarResult = '';
    });
  }

  void _calculate(String operation) {
    HapticFeedback.lightImpact();
    setState(() {
      scalarResult = '';
      try {
        switch (operation) {
          case 'A + B':
            resultMatrix = MatrixModel.add(matrixA, matrixB);
            break;
          case 'A - B':
            resultMatrix = MatrixModel.subtract(matrixA, matrixB);
            break;
          case 'A × B':
            resultMatrix = MatrixModel.multiply(matrixA, matrixB);
            break;
          case 'Det(A)':
            double d = MatrixModel.determinant(matrixA);
            scalarResult = 'Det(A) = $d';
            resultMatrix = null;
            break;
          case 'Inv(A)':
            resultMatrix = MatrixModel.inverse(matrixA);
            break;
          case 'Transpose(A)':
            resultMatrix = MatrixModel.transpose(matrixA);
            break;
        }
      } catch (e) {
        scalarResult = 'Error: ${e.toString().replaceAll("Exception: ", "")}';
        resultMatrix = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Matrix A Editor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CalculatorTheme.scientificText)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Rows: ', style: TextStyle(color: CalculatorTheme.textMuted)),
              _buildDropdown(_rowsA, (v) => _resizeMatrixA(v!, _colsA)),
              const SizedBox(width: 24),
              const Text('Cols: ', style: TextStyle(color: CalculatorTheme.textMuted)),
              _buildDropdown(_colsA, (v) => _resizeMatrixA(_rowsA, v!)),
            ],
          ),
          const SizedBox(height: 10),
          _buildMatrixGrid(matrixA),
          const SizedBox(height: 20),

          const Text('Matrix B Editor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CalculatorTheme.scientificText)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Rows: ', style: TextStyle(color: CalculatorTheme.textMuted)),
              _buildDropdown(_rowsB, (v) => _resizeMatrixB(v!, _colsB)),
              const SizedBox(width: 24),
              const Text('Cols: ', style: TextStyle(color: CalculatorTheme.textMuted)),
              _buildDropdown(_colsB, (v) => _resizeMatrixB(_rowsB, v!)),
            ],
          ),
          const SizedBox(height: 10),
          _buildMatrixGrid(matrixB),
          const SizedBox(height: 24),

          // Operations
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildOpBtn('A + B'),
              _buildOpBtn('A - B'),
              _buildOpBtn('A × B'),
              _buildOpBtn('Det(A)'),
              _buildOpBtn('Inv(A)'),
              _buildOpBtn('Transpose(A)'),
            ],
          ),
          const SizedBox(height: 24),

          const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CalculatorTheme.textMuted)),
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
                child: scalarResult.isNotEmpty
                    ? Text(scalarResult, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace'))
                    : resultMatrix == null
                        ? const Text('No result computed.', style: TextStyle(color: CalculatorTheme.textMuted))
                        : Column(
                            children: resultMatrix!.data.map((row) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: row.map((val) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(4),
                                    child: Text(
                                      val == val.toInt() ? val.toInt().toString() : val.toStringAsFixed(2),
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                    ),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(int value, ValueChanged<int?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: CalculatorTheme.keyBase,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CalculatorTheme.glassBorder),
      ),
      child: DropdownButton<int>(
        value: value,
        dropdownColor: CalculatorTheme.keyBase,
        underline: const SizedBox(),
        items: [2, 3].map((v) => DropdownMenuItem(value: v, child: Text('$v', style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMatrixGrid(MatrixModel m) {
    return Column(
      children: List.generate(m.rows, (r) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(m.cols, (c) {
            return Container(
              width: 70,
              height: 50,
              margin: const EdgeInsets.all(6),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                controller: TextEditingController(text: m.data[r][c].toString())
                  ..selection = TextSelection.fromPosition(TextPosition(offset: m.data[r][c].toString().length)),
                onChanged: (val) {
                  double? parsed = double.tryParse(val);
                  if (parsed != null) {
                    m.setElement(r, c, parsed);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: CalculatorTheme.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: CalculatorTheme.scientificText, width: 2),
                  ),
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: CalculatorTheme.keyBase,
                ),
                style: const TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'monospace'),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildOpBtn(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CalculatorTheme.keyScientific,
        foregroundColor: CalculatorTheme.scientificText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: CalculatorTheme.glassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () => _calculate(label),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
