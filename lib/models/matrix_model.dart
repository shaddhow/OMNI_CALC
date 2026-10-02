class MatrixModel {
  final int rows;
  final int cols;
  final List<List<double>> data;

  MatrixModel(this.rows, this.cols, [List<List<double>>? initialData])
      : data = initialData ?? List.generate(rows, (_) => List.filled(cols, 0.0));

  MatrixModel copy() {
    return MatrixModel(
      rows,
      cols,
      data.map((row) => List<double>.from(row)).toList(),
    );
  }

  void setElement(int r, int c, double val) {
    if (r >= 0 && r < rows && c >= 0 && c < cols) {
      data[r][c] = val;
    }
  }

  double getElement(int r, int c) => data[r][c];

  static MatrixModel add(MatrixModel a, MatrixModel b) {
    if (a.rows != b.rows || a.cols != b.cols) {
      throw Exception("Dimension Error");
    }
    MatrixModel result = MatrixModel(a.rows, a.cols);
    for (int i = 0; i < a.rows; i++) {
      for (int j = 0; j < a.cols; j++) {
        result.data[i][j] = a.data[i][j] + b.data[i][j];
      }
    }
    return result;
  }

  static MatrixModel subtract(MatrixModel a, MatrixModel b) {
    if (a.rows != b.rows || a.cols != b.cols) {
      throw Exception("Dimension Error");
    }
    MatrixModel result = MatrixModel(a.rows, a.cols);
    for (int i = 0; i < a.rows; i++) {
      for (int j = 0; j < a.cols; j++) {
        result.data[i][j] = a.data[i][j] - b.data[i][j];
      }
    }
    return result;
  }

  static MatrixModel multiply(MatrixModel a, MatrixModel b) {
    if (a.cols != b.rows) {
      throw Exception("Dimension Error");
    }
    MatrixModel result = MatrixModel(a.rows, b.cols);
    for (int i = 0; i < a.rows; i++) {
      for (int j = 0; j < b.cols; j++) {
        double sum = 0;
        for (int k = 0; k < a.cols; k++) {
          sum += a.data[i][k] * b.data[k][j];
        }
        result.data[i][j] = sum;
      }
    }
    return result;
  }

  static double determinant(MatrixModel m) {
    if (m.rows != m.cols) {
      throw Exception("Not a square matrix");
    }
    int n = m.rows;
    if (n == 1) return m.data[0][0];
    if (n == 2) {
      return m.data[0][0] * m.data[1][1] - m.data[0][1] * m.data[1][0];
    }
    if (n == 3) {
      double a = m.data[0][0], b = m.data[0][1], c = m.data[0][2];
      double d = m.data[1][0], e = m.data[1][1], f = m.data[1][2];
      double g = m.data[2][0], h = m.data[2][1], i = m.data[2][2];
      return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
    }
    throw Exception("Only 2x2 and 3x3 supported");
  }

  static MatrixModel transpose(MatrixModel m) {
    MatrixModel result = MatrixModel(m.cols, m.rows);
    for (int i = 0; i < m.rows; i++) {
      for (int j = 0; j < m.cols; j++) {
        result.data[j][i] = m.data[i][j];
      }
    }
    return result;
  }

  static MatrixModel inverse(MatrixModel m) {
    double det = determinant(m);
    if (det.abs() < 1e-9) {
      throw Exception("Matrix is singular (det = 0)");
    }
    int n = m.rows;
    if (n == 2) {
      MatrixModel adj = MatrixModel(2, 2, [
        [m.data[1][1], -m.data[0][1]],
        [-m.data[1][0], m.data[0][0]]
      ]);
      MatrixModel inv = MatrixModel(2, 2);
      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          inv.data[i][j] = adj.data[i][j] / det;
        }
      }
      return inv;
    } else if (n == 3) {
      double a = m.data[0][0], b = m.data[0][1], c = m.data[0][2];
      double d = m.data[1][0], e = m.data[1][1], f = m.data[1][2];
      double g = m.data[2][0], h = m.data[2][1], i = m.data[2][2];

      List<List<double>> cof = [
        [ (e*i - f*h), -(d*i - f*g),  (d*h - e*g) ],
        [ -(b*i - c*h),  (a*i - c*g), -(a*h - b*g) ],
        [ (b*f - c*e), -(a*f - c*d),  (a*e - b*d) ]
      ];
      MatrixModel adj = MatrixModel(3, 3);
      for (int r = 0; r < 3; r++) {
        for (int cIdx = 0; cIdx < 3; cIdx++) {
          adj.data[r][cIdx] = cof[cIdx][r];
        }
      }
      MatrixModel inv = MatrixModel(3, 3);
      for (int r = 0; r < 3; r++) {
        for (int cIdx = 0; cIdx < 3; cIdx++) {
          inv.data[r][cIdx] = adj.data[r][cIdx] / det;
        }
      }
      return inv;
    }
    throw Exception("Inverse supported for 2x2 and 3x3");
  }
}
