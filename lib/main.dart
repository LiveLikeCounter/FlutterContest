import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _starController;
  AnimationController _moonController;
  Map<String, dynamic> _targetPositions = {
    'star': {
      'latitude': 31.77765,
      'longitude': 35.23547,
    },
    'moon': {
      'latitude': 21.3891,
      'longitude': 39.8579,
    },
  };

  double _getIconAlignment(
    double deviceAngle,
    Position devicePosition,
    String target,
  ) {
    double dy = _targetPositions[target]['latitude'] - devicePosition.latitude;
    double dx = math.cos(math.pi / 180 * devicePosition.latitude) *
        (_targetPositions[target]['longitude'] - devicePosition.longitude);
    double targetAngle = ((math.atan2(dy, dx) - 1.5708) * (180 / math.pi)) * -1;
    double diff = deviceAngle - targetAngle;
    int angle = (diff < -180 ? 360 + diff : diff).round();
    if (angle > 100) {
      angle = 100;
    } else if (angle < -100) {
      angle = -100;
    }
    return angle / 100;
  }

  @override
  void initState() {
    super.initState();

    _starController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 0.5,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
        this.setState(() {});
      });
    _moonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 0.5,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
        this.setState(() {});
      });

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      FlutterCompass.events.listen((double direction) {
        _starController.animateTo(_getIconAlignment(
          direction,
          position,
          'star',
        ));
        _moonController.animateTo(_getIconAlignment(
          direction,
          position,
          'moon',
        ));
      });
    });
  }

  Animation<Alignment> _getIconAnimation(String icon) {
    AnimationController _controller;
    double top;

    if (icon == 'star') {
      _controller = _starController;
      top = -0.25;
    } else {
      _controller = _moonController;
      top = 0.25;
    }

    return Tween(
      begin: Alignment(-1.0, top),
      end: Alignment(1.0, top),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Faith Compass'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
              painter: CurvePainter(),
            ),
            FractionallySizedBox(
              heightFactor: 0.2,
              widthFactor: 0.2,
              alignment: _getIconAnimation('star').value,
              child: getFaithIcon('star'),
            ),
            FractionallySizedBox(
              heightFactor: 0.2,
              widthFactor: 0.2,
              alignment: _getIconAnimation('moon').value,
              child: getFaithIcon('moon'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getFaithIcon(String filename) {
  return Container(
    padding: EdgeInsets.all(12),
    child: new SvgPicture.asset(
      'assets/icons/$filename.svg',
      color: Colors.white,
      semanticsLabel: 'A red up arrow',
      fit: BoxFit.contain,
    ),
    decoration: new BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
  );
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black12;
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      paint,
    );
    paint.color = Colors.blueAccent;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
