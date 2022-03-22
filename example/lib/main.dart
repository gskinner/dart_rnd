import 'package:flutter/material.dart';
import 'package:rnd/rnd.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curve Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Curve Distribution Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedCurve = 'linear (or none)';
  String selectedHue = 'blue';

  @override
  Widget build(BuildContext context) {
    _runTests();

    List<DropdownMenuItem<String>> curves = [];
    curveMap.forEach((k, v) {
      curves.add(DropdownMenuItem<String>(value: k, child: Text(k), ));
    });

    List<DropdownMenuItem<String>> hues = [];
    hueMap.forEach((k, v) {
      hues.add(DropdownMenuItem<String>(value: k, child: Text(k), ));
    });

    Curve? curve = curveMap[selectedCurve];
    double? hue = hueMap[selectedHue];
    List<ColoredPoint> points = [];
    
    for (int i=0; i<25000; i++) {
      points.add(ColoredPoint(
        rnd.getDouble(0, 1, curve: curve),
        rnd.getDouble(0, 1),
        rnd.getColor(
          hue: hue,
          hueRange: 45,
          saturation: 1.0,
          lightness: 0.5,
          opacity: 0.5,
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.stretch, children:[
        Container(
          color: Colors.white,
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _getValueLabel("0 →"),
            DropdownButton(
              value: selectedCurve,
              onChanged: (item) => setState(() { selectedCurve = item as String; }),
              items: curves,
            ),
            DropdownButton(
              value: selectedHue,
              onChanged: (item) => setState(() { selectedHue = item as String; }),
              items: hues,
            ),
            _getValueLabel("← 1"),
          ],),
        ),
        Expanded(child: CustomPaint(
          painter: _PointPainter(points: points),
          child: Container(),
        )),
      ]),
    );
  }

  Widget _getValueLabel(String label) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

void _runTests() {
  // TODO: these should get moved to proper tests and/or visualized.
  print("\n------------------\nBASIC TESTS:");
  _runTest("rnd()", ()=>rnd());
  _runTest("rnd(10)", ()=>rnd(10));
  _runTest("rnd(10, 20)", ()=>rnd(10, 20));
  print("rndSeed: $rndSeed");

  print("\n------------------\nNUMERIC TESTS:");
  _runTest("int, 40-50, easeOut", ()=>rnd.getInt(40, 50, curve:Curves.easeOutQuint));
  _runTest("double, 40-50, easeOut", ()=>rnd.getDouble(40, 50, curve:Curves.easeOutQuint).toStringAsFixed(2));
  _runTest("bool, 0.75", ()=>rnd.getBool(0.75));
  _runTest("bit, 0.75", ()=>rnd.getBit(0.75));
  _runTest("sign, 0.75", ()=>rnd.getSign(0.75));
  _runTest("deg", ()=>rnd.getDeg());
  _runTest("rad", ()=>rnd.getRad());

  print("\n------------------\nCOLOR TESTS:");
  _runTest("color", ()=>rnd.getColor());
  _runTest("red", ()=>rnd.getColor(hue: Hue.red, hueRange: 20, minSaturation: 0.5, lightness: 0.5));
  _runTest("magenta->yellow", ()=>rnd.getColor(minHue: Hue.magenta, maxHue: Hue.yellow, saturation: 1.0, lightness: 0.5));
  _runTest("opacity > 0.5", ()=>rnd.getColor(minOpacity: 0.5, lightness: 0.0));

  List<String> list = ["zero", "one", "two", "three", "four"];
  List<String> shuffled = rnd.shuffle(list, copy: true);

  print("\n------------------\nLIST TESTS:");
  print('list: $list');
  print('shuffled: $shuffled');

  _runTest("item, false", (){
    String str = rnd.getItem(list); // test typing
    return str;
  }, 2);
  print('list: $list');

  _runTest("item, true", ()=>rnd.getItem(list, remove:true), 2);
  print('list: $list');
}

_runTest(String label, Function f, [int count=5]) {
  String str = '$label: [';
  for (int i=0; i<count; i++) { str += '${i>0?', ':''}${f()}'; }
  print('$str]');
}

class _PointPainter extends CustomPainter {
  List<ColoredPoint> points;

  _PointPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length == 0) { return; }
    Paint dot = new Paint();
    dot.blendMode = BlendMode.screen;
    int l = points.length;
    for (int i=0; i < l; i++) {
      ColoredPoint pt = points[i];
      dot.color = pt.color;
      canvas.drawCircle(pt.alongSize(size), 1.7, dot);
    }
  }

  @override
  bool shouldRepaint(_PointPainter oldPainter) {
    return true;
  }

}

class ColoredPoint {
  final double x;
  final double y;
  final Color color;
  ColoredPoint(this.x, this.y, this.color);

  Offset alongSize(Size size) {
    return Offset(x * size.width, y * size.height);
  }
}

const Map<String, double> hueMap = {
  'red': Hue.red,
  'green': Hue.green,
  'blue': Hue.blue,
  'yellow': Hue.yellow,
  'cyan': Hue.cyan,
  'magenta': Hue.magenta,
};

// Curves that return values outside 0-1 are commented out.
const Map<String, Curve> curveMap = {
  'bounceIn': Curves.bounceIn,
  'bounceInOut': Curves.bounceInOut,
  'bounceOut': Curves.bounceOut,
  'decelerate': Curves.decelerate,
  'ease': Curves.ease,
  'easeIn': Curves.easeIn,
//'easeInBack': Curves.easeInBack,
  'easeInCirc': Curves.easeInCirc,
  'easeInCubic': Curves.easeInCubic,
  'easeInExpo': Curves.easeInExpo,
  'easeInOut': Curves.easeInOut,
//'easeInOutBack': Curves.easeInOutBack,
  'easeInOutCirc': Curves.easeInOutCirc,
  'easeInOutCubic': Curves.easeInOutCubic,
  'easeInOutExpo': Curves.easeInOutExpo,
  'easeInOutQuad': Curves.easeInOutQuad,
  'easeInOutQuart': Curves.easeInOutQuart,
  'easeInOutQuint': Curves.easeInOutQuint,
  'easeInOutSine': Curves.easeInOutSine,
  'easeInQuad': Curves.easeInQuad,
  'easeInQuart': Curves.easeInQuart,
  'easeInQuint': Curves.easeInQuint,
  'easeInSine': Curves.easeInSine,
  'easeInToLinear': Curves.easeInToLinear,
  'easeOut': Curves.easeOut,
//'easeOutBack': Curves.easeOutBack,
  'easeOutCirc': Curves.easeOutCirc,
  'easeOutCubic': Curves.easeOutCubic,
  'easeOutExpo': Curves.easeOutExpo,
  'easeOutQuad': Curves.easeOutQuad,
  'easeOutQuart': Curves.easeOutQuart,
  'easeOutQuint': Curves.easeOutQuint,
  'easeOutSine': Curves.easeOutSine,
//'elasticIn': Curves.elasticIn,
//'elasticInOut': Curves.elasticInOut,
//'elasticOut': Curves.elasticOut,
  'fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
  'fastOutSlowIn': Curves.fastOutSlowIn,
  'linear (or none)': Curves.linear,
  'linearToEaseOut': Curves.linearToEaseOut,
  'slowMiddle': Curves.slowMiddle,
};