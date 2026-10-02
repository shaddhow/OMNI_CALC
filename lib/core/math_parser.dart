import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

enum AngleUnit { deg, rad }

class MathParser {
  static String evaluate(
    String expressionStr,
    AngleUnit angleUnit, {
    double? ans,
    Map<String, double>? registers,
  }) {
    if (expressionStr.trim().isEmpty) return '';

    try {
      String processed = expressionStr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi')
          .replaceAll('√(', 'sqrt(')
          .replaceAll('∛(', 'cbrt(')
          .replaceAll('log(', 'log10(')
          .replaceAll('ln(', 'ln(');

      // Replace memory registers & Ans
      final double ansVal = ans ?? registers?['Ans'] ?? 0.0;
      processed = processed.replaceAll('Ans', ansVal.toString());

      if (registers != null) {
        for (final entry in registers.entries) {
          if (entry.key != 'Ans') {
            // Replace standalone register letters A, B, C, D, X, Y
            processed = processed.replaceAllMapped(
              RegExp(r'\b' + entry.key + r'\b'),
              (_) => entry.value.toString(),
            );
          }
        }
      }

      processed = _addImplicitMultiplication(processed);
      processed = _handleTrigFunctions(processed, angleUnit);

      ShuntingYardParser p = ShuntingYardParser();
      Expression exp = p.parse(processed);
      ContextModel cm = ContextModel();

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      if (evalResult.isNaN || evalResult.isInfinite) {
        return 'Math Error';
      }

      if (evalResult == evalResult.toInt() && evalResult.abs() < 1e12) {
        return evalResult.toInt().toString();
      } else if (evalResult.abs() > 1e10 || (evalResult.abs() < 1e-4 && evalResult != 0)) {
        return evalResult.toStringAsExponential(8);
      } else {
        String resStr = evalResult.toString();
        if (resStr.contains('.')) {
          List<String> parts = resStr.split('.');
          if (parts[1].length > 8) {
            resStr = evalResult.toStringAsFixed(8);
            resStr = resStr.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
        }
        return resStr;
      }
    } catch (e) {
      return 'Syntax Error';
    }
  }

  static String _addImplicitMultiplication(String expr) {
    String result = expr;
    // 2( -> 2*(, 2pi -> 2*pi, 2sin -> 2*sin, 2x -> 2*x
    result = result.replaceAllMapped(RegExp(r'(\d)(\()'), (m) => '${m[1]}*${m[2]}');
    result = result.replaceAllMapped(RegExp(r'(\d)([a-zA-Zπe])'), (m) => '${m[1]}*${m[2]}');
    // )( -> )*(
    result = result.replaceAllMapped(RegExp(r'(\))(\()'), (m) => '${m[1]}*${m[2]}');
    // )\d -> )*\d
    result = result.replaceAllMapped(RegExp(r'(\))(\d)'), (m) => '${m[1]}*${m[2]}');
    // )a -> )*a
    result = result.replaceAllMapped(RegExp(r'(\))([a-zA-Zπe])'), (m) => '${m[1]}*${m[2]}');
    // (pi|e)( -> (pi|e)*(
    result = result.replaceAllMapped(RegExp(r'(pi|e)(\()'), (m) => '${m[1]}*${m[2]}');
    // (pi|e)\d -> (pi|e)*\d
    result = result.replaceAllMapped(RegExp(r'(pi|e)(\d)'), (m) => '${m[1]}*${m[2]}');
    return result;
  }

  static String _handleTrigFunctions(String expr, AngleUnit angleUnit) {
    if (angleUnit == AngleUnit.deg) {
      expr = expr.replaceAll('sin(', 'sin((${math.pi}/180)*');
      expr = expr.replaceAll('cos(', 'cos((${math.pi}/180)*');
      expr = expr.replaceAll('tan(', 'tan((${math.pi}/180)*');
      expr = expr.replaceAll('asin(', '(180/${math.pi})*asin(');
      expr = expr.replaceAll('acos(', '(180/${math.pi})*acos(');
      expr = expr.replaceAll('atan(', '(180/${math.pi})*atan(');
    }
    expr = expr.replaceAll('log10(', 'log(');
    return expr;
  }
}
