import 'dart:math' as math;

class EquationModel {
  // Quadratic: ax^2 + bx + c = 0
  static List<String> solveQuadratic(double a, double b, double c) {
    if (a == 0) {
      if (b == 0) return ['No solution'];
      return ['x = ${-c / b}'];
    }
    double discriminant = b * b - 4 * a * c;
    if (discriminant > 0) {
      double x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      double x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      return ['x₁ = $x1', 'x₂ = $x2'];
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      return ['x = $x'];
    } else {
      double real = -b / (2 * a);
      double imag = math.sqrt(-discriminant) / (2 * a);
      return ['x₁ = $real + ${imag}i', 'x₂ = $real - ${imag}i'];
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
    return ['x = $x', 'y = $y'];
  }
}
