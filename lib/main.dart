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

class _MyAppState extends State<MyApp> {
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
  int getTargetOffsetAngle(double deviceAngle, Position devicePosition, String target) {
    double dy = _targetPositions[target]['latitude'] - devicePosition.latitude;
    double dx = math.cos(math.pi / 180 * devicePosition.latitude) *
        (_targetPositions[target]['longitude'] - devicePosition.longitude);
    double targetAngle = ((math.atan2(dy, dx) - 1.5708) * (180 / math.pi)) * -1;
    double diff = deviceAngle - targetAngle;
    return (diff < -180 ? 360 + diff : diff).round();
  }

  Widget getFaithIcon(String filename) {
    return Container(
      padding: EdgeInsets.all(12),
      child: SvgPicture.asset(
        'assets/icons/$filename.svg',
        color: Colors.white,
        semanticsLabel: 'A red up arrow',
        fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      FlutterCompass.events.listen((double direction) {
        int star = getTargetOffsetAngle(direction, position, 'star');
        int moon = getTargetOffsetAngle(direction, position, 'moon');
        print('>>> STAR: $star, MOON: $moon');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Faith Compass'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  Expanded(child: getFaithIcon('cross')),
                  Spacer(),
                  Expanded(child: getFaithIcon('judaism')),
                  Spacer(),
                  Expanded(child: getFaithIcon('islam')),
                  Spacer(),
                ],
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
