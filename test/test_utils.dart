// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.test_utils;

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

Vector2 $v2(double x, double y) => Vector2(x, y);

Vector3 $v3(double x, double y, double z) => Vector3(x, y, z);

Vector4 $v4(double x, double y, double z, double w) => Vector4(x, y, z, w);

void relativeTest(dynamic output, dynamic expectedOutput) {
  final num errorThreshold = 0.0005;
  num error = relativeError(output, expectedOutput).abs();
  expect(error >= errorThreshold, isFalse,
      reason: '$output != $expectedOutput : relativeError = $error');
}

void absoluteTest(dynamic output, dynamic expectedOutput) {
  final num errorThreshold = 0.0005;
  num error = absoluteError(output, expectedOutput).abs();
  expect(error >= errorThreshold, isFalse,
      reason: '$output != $expectedOutput : absoluteError = $error');
}

dynamic makeMatrix(int rows, int cols) {
  if (rows != cols) {
    return null;
  }

  if (cols == 2) {
    return Matrix2.zero();
  }
  if (cols == 3) {
    return Matrix3.zero();
  }
  if (cols == 4) {
    return Matrix4.zero();
  }

  return null;
}

T parseMatrix<T>(String input) {
  input = input.trim();
  List<String> rows = input.split("\n");
  List<double> values = <double>[];
  int col_count = 0;
  for (int i = 0; i < rows.length; i++) {
    rows[i] = rows[i].trim();
    List<String> cols = rows[i].split(" ");
    for (int j = 0; j < cols.length; j++) {
      cols[j] = cols[j].trim();
    }

    for (int j = 0; j < cols.length; j++) {
      if (cols[j].isEmpty) {
        continue;
      }
      if (i == 0) {
        col_count++;
      }
      values.add(double.parse(cols[j]));
    }
  }

  dynamic m = makeMatrix(rows.length, col_count);
  for (int j = 0; j < rows.length; j++) {
    for (int i = 0; i < col_count; i++) {
      m[m.index(j, i)] = values[j * col_count + i];
      //m[i][j] = values[j*col_count+i];
    }
  }

  return m as T;
}

T parseVector<T extends Vector>(String v) {
  v = v.trim();
  Pattern pattern = RegExp('[\\s]+', multiLine: true, caseSensitive: false);
  List<String> rows = v.split(pattern);
  List<double> values = <double>[];
  for (int i = 0; i < rows.length; i++) {
    rows[i] = rows[i].trim();
    if (rows[i].isEmpty) {
      continue;
    }
    values.add(double.parse(rows[i]));
  }

  Vector r;
  if (values.length == 2) {
    r = Vector2(values[0], values[1]);
  } else if (values.length == 3) {
    r = Vector3(values[0], values[1], values[2]);
  } else if (values.length == 4) {
    r = Vector4(values[0], values[1], values[2], values[3]);
  }

  return r as T;
}
