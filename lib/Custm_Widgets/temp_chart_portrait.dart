import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'temp_chart_landscape.dart';

class TempChart extends StatefulWidget {
  const TempChart({Key? key, required this.value}) : super(key: key);

  final String value;
  @override
  _MyTempChartState createState() => _MyTempChartState();
}

class _MyTempChartState extends State<TempChart> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  double _temperature = 0;
  double _interval = 1, _minimum = -50, _maximum = 50;
  Timer? timer1, timer2;

  @override
  void initState() {
    chartData = getChartData();
    _temperature = getTempData();
    selectInterval();
    timer1 = Timer.periodic(const Duration(seconds: 1), updateDataSource);
    timer2 = Timer.periodic(const Duration(seconds: 1), updateInterval);
    super.initState();
  }

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  updateInterval(Timer time) {
    switch (widget.value) {
      case 'temperature':
        setState(() {
          _minimum = _temperature - 10;
          _maximum = _temperature + 10;
        });
        break;
      case 'humidite':
        setState(() {
          _minimum = 0;
          _maximum = 100;
        });
        break;
      case 'pression':
        setState(() {
          _minimum = _temperature - 500;
          _maximum = _temperature + 500;
        });
        break;
    }
  }

  selectInterval() {
    switch (widget.value) {
      case 'temperature':
        _interval = 0.5;
        break;
      case 'humidite':
        _interval = 5;
        break;
      case 'pression':
        _interval = 50;
        break;
      default:
        _interval = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            SfCartesianChart(
              series: <LineSeries<LiveData, int>>[
                LineSeries<LiveData, int>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: chartData,
                  color: Colors.blue,
                  xValueMapper: (LiveData sales, _) => sales.time,
                  yValueMapper: (LiveData sales, _) => sales.value,
                )
              ],
              primaryXAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 5,
                  title: AxisTitle(text: 'Time (seconds)')),
              primaryYAxis: NumericAxis(
                  minimum: _minimum,
                  maximum: _maximum,
                  interval: _interval,
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: widget.value)),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(130, 30),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TempChartLandscape(
                            value: widget.value,
                          )));
                },
                child: Row(children: const [
                  Icon(Icons.fullscreen, color: Colors.grey),
                  SizedBox(width: 3),
                  Text('Fullscreen')
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double getTempData() {
    DatabaseReference _ref =
        FirebaseDatabase.instance.ref().child('Data/${widget.value}');
    _ref.onValue.listen((event) {
      _temperature = double.parse(event.snapshot.value.toString());
    });
    return _temperature;
  }

  int time = 20;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, _temperature));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, _temperature),
      LiveData(1, _temperature),
      LiveData(2, _temperature),
      LiveData(3, _temperature),
      LiveData(4, _temperature),
      LiveData(5, _temperature),
      LiveData(6, _temperature),
      LiveData(7, _temperature),
      LiveData(8, _temperature),
      LiveData(9, _temperature),
      LiveData(10, _temperature),
      LiveData(11, _temperature),
      LiveData(12, _temperature),
      LiveData(13, _temperature),
      LiveData(14, _temperature),
      LiveData(15, _temperature),
      LiveData(16, _temperature),
      LiveData(17, _temperature),
      LiveData(18, _temperature),
      LiveData(19, _temperature)
    ];
  }
}

class LiveData {
  LiveData(this.time, this.value);
  final int time;
  final num value;
}
