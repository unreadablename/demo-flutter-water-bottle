import 'dart:async';

import 'package:bottle/pathes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "BO'OH'O'WA'ER"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _value = 0.5;

  void _incrementCounter() {
    setState(() {
      _value = _value + 0.1;
      if (_value > 1) {
        _value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 2 / 3,
          widthFactor: 2 / 3,
          child: Bottle(value: _value),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Bottle extends StatefulWidget {
  const Bottle({super.key, required this.value});
  final double value;

  @override
  _BottleState createState() => _BottleState();
}

extension RectAspectRatioExtension on Rect {
  double get aspectRatio => width / height;
}

class _BottleState extends State<Bottle> with TickerProviderStateMixin {
  late final AnimationController firstController;
  late final Animation<double> firstAnimation;

  late final AnimationController secondController;
  late final Animation<double> secondAnimation;

  late final AnimationController thirdController;
  late final Animation<double> thirdAnimation;

  late final AnimationController fourthController;
  late final Animation<double> fourthAnimation;

  final PathBuilder clipPathBuilder = getBottlePath;
  final PathBuilder pathBuilder = getBottlePath;

  late final bottlePath = pathBuilder();
  late final aspectRatio = bottlePath.getBounds().aspectRatio;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    firstAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    secondAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    thirdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    thirdAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    fourthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fourthAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: fourthController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    Timer(
      const Duration(seconds: 2),
      () => firstController.repeat(reverse: true),
    );

    Timer(
      const Duration(milliseconds: 1600),
      () => secondController.repeat(reverse: true),
    );

    Timer(
      const Duration(milliseconds: 800),
      () => thirdController.repeat(reverse: true),
    );

    fourthController.repeat(reverse: true);
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CustomPaint(
            painter: MyPainter(
              widget.value,
              clipPathBuilder,
              firstAnimation.value,
              secondAnimation.value,
              thirdAnimation.value,
              fourthAnimation.value,
            ),
            foregroundPainter: BottlePainter(
              pathBuilder: pathBuilder,
              painter: Paint()
                ..color = Colors.black
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke,
            ),
          ),
        ),
      ),
    );
  }
}

typedef PathBuilder = Path Function([Size? size]);

class MyPainter extends CustomPainter {
  final double value;

  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;

  final PathBuilder clipPathBuilder;

  MyPainter(
    this.value,
    this.clipPathBuilder,
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Path clipPath = clipPathBuilder(size);

    canvas.clipPath(clipPath);

    if (value != 0) {
      var waterPaint = Paint()
        ..color = const Color(0xff3B6ABA).withOpacity(.8)
        ..style = PaintingStyle.fill;

      final y = size.height - size.height * value;

      final y1 = y * firstValue;
      final y2 = y * secondValue;
      final y3 = y * thirdValue;
      final y4 = y * fourthValue;

      var waterPath = Path()
        ..moveTo(0, y1)
        ..cubicTo(
          size.width * .4,
          y2,
          size.width * .7,
          y3,
          size.width,
          y4,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);

      canvas.drawPath(waterPath, waterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BottlePainter extends CustomPainter {
  final PathBuilder pathBuilder;
  final Paint painter;

  BottlePainter({
    required this.pathBuilder,
    required this.painter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = pathBuilder(size);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
