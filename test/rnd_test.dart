import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:rnd/rnd.dart';

void main() {
  final int seed = 42;
  test('RndExtensions call() no arguments functions like nextDouble()', () {
    expect(Random(seed)(), Random(seed).nextDouble());
  });
  test('RndExtensions call(max) functions like getDouble(0, max)', () {    
    expect(Random(seed)(100.2), Random(seed).getDouble(0, 100.2));
  });
  test('RndExtensions call(min, max) functions like getDouble(min, max)', () {    
    expect(Random(seed)(-100.2, 100.2), Random(seed).getDouble(-100.2, 100.2));
  });
  test('RndExtensions call(null, max) fails with an exception', () {    
    expect(() => Random(seed)(null, 100.2), throwsArgumentError);
  });
}
