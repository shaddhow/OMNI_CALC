import 'dart:math' as math;

class EquationModel {
  // Quadratic: ax^2 + bx + c = 0
  static List<String> solveQuadratic(double a, double b, double c) {
    if (a == 0) {
      if (b == 0) return ['No solution'];
      return ['x = ${_formatNum(-c / b)}'];
    }
    double discriminant = b * b - 4 * a * c;
    if (discriminant > 0) {
      double x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      double x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      return ['x₁ = ${_formatNum(x1)}', 'x₂ = ${_formatNum(x2)}'];
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      return ['x = ${_formatNum(x)}'];
    } else {
      double real = -b / (2 * a);
      double imag = math.sqrt(-discriminant) / (2 * a);
      return [
        'x₁ = ${_formatNum(real)} + ${_formatNum(imag)}i',
        'x₂ = ${_formatNum(real)} - ${_formatNum(imag)}i'
      ];
    }
  }

  // Simultaneous 2x2:
  // a1*x + b1*y = c1
  // a2*x + b2*y = c2
  static List<String> solveSimultaneous2x2(
      double a1, double b1, double c1, double a2, double b2, double c2) {
    double det = a1 * b2 - a2 * b1;
    if (det.abs() < 1e-9) {
      return ['Infinite or No Solutions'];
    }
    double x = (c1 * b2 - c2 * b1) / det;
    double y = (a1 * c2 - a2 * c1) / det;
    return ['x = ${_formatNum(x)}', 'y = ${_formatNum(y)}'];
  }

  // Simultaneous 3x3:
  // a1*x + b1*y + c1*z = d1
  // a2*x + b2*y + c2*z = d2
  // a3*x + b3*y + c3*z = d3
  static List<String> solveSimultaneous3x3(
      double a1, double b1, double c1, double d1,
      double a2, double b2, double c2, double d2,
      double a3, double b3, double c3, double d3) {
    double det = _det3(
      a1, b1, c1,
      a2, b2, c2,
      a3, b3, c3,
    );

    if (det.abs() < 1e-9) {
      return ['Infinite or No Solutions'];
    }

    double detX = _det3(
      d1, b1, c1,
      d2, b2, c2,
      d3, b3, c3,
    );

    double detY = _det3(
      a1, d1, c1,
      a2, d2, c2,
      a3, d3, c3,
    );

    double detZ = _det3(
      a1, b1, d1,
      a2, b2, d2,
      a3, b3, d3,
    );

    double x = detX / det;
    double y = detY / det;
    double z = detZ / det;

    return [
      'x = ${_formatNum(x)}',
      'y = ${_formatNum(y)}',
      'z = ${_formatNum(z)}',
    ];
  }

  static double _det3(
      double a, double b, double c,
      double d, double e, double f,
      double g, double h, double i) {
    return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
  }

  static String _formatNum(double val) {
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
