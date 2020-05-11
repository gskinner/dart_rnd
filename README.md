# dart_rnd
Extension methods &amp; helpers for Random in Dart, and a globally accessible instance. Ex. rnd(10), rnd.getItem(list), rnd.getBit(0.8).
# rnd package
Makes working with random values in Dart / Flutter easier:

1. It provides an easy to access, global instance of Random.
2. It adds helpful extension methods to Random.

# Global instance
To make it easy to set up and propagate a `Random` instance throughout your app, the rnd package exposes a
global instance via the `rnd` property. This makes generating a random value as simple as:

```dart
import 'package:rnd/rnd.dart';
rnd(10); // random double between 0-10
rnd.getBool(0.8); // 80% chance to get true
```

You can also get and set the seed for the global instance via `rndSeed`.

# Extension methods on Random
Adds the following methods to all instances of `Random`. Read the docs for more info.

- `getInt(min, max, {curve})` // see "Curves" below
- `getDouble(min, max, {curve})`
- `getBool(chance)`
- `getBit(chance)` // 0 or 1
- `getSign(chance)` // -1 or 1
- `getDeg()` // 0-360
- `getRad()` // 0-2pi
- `getColor({...})` // see docs for params
- `getItem(list, {remove, curve})`
- `shuffle(list, {copy})` // randomize list

It also defines a `call` method, which lets you get a random double value by calling a `Random` instance directly:

```dart
Random myRandom = new Random();
print(myRandom()); // double between 0-1
print(myRandom(10)); // 0-10
print(myRandom(5,10)); // 5-10
```

This pairs well with the global instance for quickly getting random values:

```dart
new Point(rnd(maxX), rnd(maxY))
```

## Curves
The `getDouble`, `getInt`, and `getItem` methods support a `curve` param which transforms the value distribution. For example:

```dart
rnd.getInt(0, 100, curve: Curves.easeIn)
```

This would favor values nearer to 0, whereas `easeOut` would favor values nearer to 100. The included `example` app visualizes the effect of different curves.

## Hue
The included `Hue` class provides named hue values for use with `getColor`. For example, `Hue.green == 120`.

```dart
rnd.getColor(hue: Hue.red); // red, green, blue, yellow, cyan, magenta
```