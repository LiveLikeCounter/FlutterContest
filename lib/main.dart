import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

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

  /// Returns positive and negative integers.
  ///
  /// Positive values mean the target is to the left.
  /// Negative values mean the target is to the right.
  /// deviceAngle and targetAngle are both relative to North.
  double _getIconAlignment(
      double deviceAngle, Position devicePosition, String target) {
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
      duration: Duration(milliseconds: 1000),
      value: 0.5,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
        this.setState(() {});
      });
    _moonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
        this.setState(() {});
      });

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      FlutterCompass.events.listen((double direction) {
        _starController.animateTo(_getIconAlignment(direction, position, 'star'));
        // _starController.animateTo(_getIconAlignment(direction, position, 'moon'));
      });
    });
  }

  Animation<Alignment> _getIconAnimation(String icon) {
    AnimationController _controller = icon == 'star' ? _starController : _moonController;
    return Tween(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    Animation<Alignment> _starAnimation = _getIconAnimation('star');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Faith Compass'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FractionallySizedBox(
              heightFactor: 0.2,
              widthFactor: 0.2,
              alignment: _starAnimation.value,
              child: getFaithIcon('star'),
            ),
          ],
        ),

        // SingleChildScrollView(
        //   child: Column(
        //     children: <Widget>[
        //       // Row(
        //       //   children: <Widget>[
        //       //     Spacer(),
        //       //     Expanded(child: getFaithIcon('cross')),
        //       //     Spacer(),
        //       //     Expanded(child: getFaithIcon('judaism')),
        //       //     Spacer(),
        //       //     Expanded(child: getFaithIcon('islam')),
        //       //     Spacer(),
        //       //   ],
        //       // ),
        //       // Container(
        //       //   child: AnimatedBuilder(
        //       //     animation: _animation,
        //       //     builder: (context, child) {
        //       //       return Transform.translate(
        //       //         offset: Offset(_animation.value, 0.0),
        //       //         child: Container(
        //       //           height: 100.0,
        //       //           width: 100.0,
        //       //           color: Colors.yellow,
        //       //         ),
        //       //       );
        //       //     },
        //       //     // child: getFaithIcon('judaism'),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
