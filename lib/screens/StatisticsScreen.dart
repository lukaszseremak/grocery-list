import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 100, pointers: <GaugePointer>[
            RangePointer(value: 30, cornerStyle: CornerStyle.bothCurve)
          ])
        ],
      )),
    );
  }
}
