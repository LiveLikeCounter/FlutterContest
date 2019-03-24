import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _direction;
//  double _lat1 = 36.778259;
//  double lat2 = 27.950575;
//  ouble _long1 = -119.417931;
//  double long2 = -82.457176;

  double dy = 28.0834343 - 28.0827146;
  double dx =
      math.cos(math.pi / 180 * (28.0827146)) * ((82.4138412) - (82.4112165));
  double angle;

  final Widget faithIconCross = Container(
    padding: EdgeInsets.all(12),
    child: new SvgPicture.asset(
      'assets/icons/cross.svg',
      color: Colors.white,
      semanticsLabel: 'A red up arrow',
      fit: BoxFit.contain,
    ),
    decoration: new BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
  );
  final Widget faithIconStar = Container(
    padding: EdgeInsets.all(12),
    child: new SvgPicture.asset(
      'assets/icons/judaism.svg',
      color: Colors.white,
      semanticsLabel: 'A red up arrow',
      fit: BoxFit.contain,
    ),
    decoration: new BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
  );
  final Widget faithIconMoon = Container(
    padding: EdgeInsets.all(12),
    child: new SvgPicture.asset(
      'assets/icons/islam.svg',
      color: Colors.white,
      semanticsLabel: 'A red up arrow',
      fit: BoxFit.contain,
    ),
    decoration: new BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
  );

  @override
  void initState() {
    super.initState();

    // commenting out to test icons
    // FlutterCompass.events.listen((double direction) {
    //   setState(() {
    //     _direction = direction;
    //     angle = math.atan2(dy, dx);
    //     print(_direction);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  Expanded(child: faithIconCross),
                  Spacer(),
                  Expanded(child: faithIconStar),
                  Spacer(),
                  Expanded(child: faithIconMoon),
                  Spacer(),
                ],
              ),
              Container(
                color: Colors.white,
                child: Transform.rotate(
                  angle: ((_direction ?? 0) * (math.pi / 180) * -1),
                  child: Stack(
                    children: <Widget>[
                      Image.asset('assets/compass.jpg'),
                      Transform.rotate(
                        angle: ((angle ?? 0)),
                        child: Image.asset('assets/compass1.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
