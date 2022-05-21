import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/models.dart';

class TempChartLandscape extends StatefulWidget {
  const TempChartLandscape({Key? key, required this.value}) : super(key: key);

  final String value;
  @override
  _MyTempChartState createState() => _MyTempChartState();
}

class _MyTempChartState extends State<TempChartLandscape> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  late GlobalKey<SfCartesianChartState> _cartesianChartKey;
  late ZoomPanBehavior _zoomPanBehavior;
  double _temperature = 0;
  double _interval = 1, _minimum = -50, _maximum = 50;
  Timer? timer1, timer2;

  @override
  void initState() {
    chartData = getChartData();
    _temperature = getTempData();
    selectInterval();
    _cartesianChartKey = GlobalKey();
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true, enablePanning: true, zoomMode: ZoomMode.xy);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.value} Data'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // TODO: TEST
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => const MyHomePage()));
              Navigator.pop(context);
            },
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          orientation = Orientation.landscape;
          return SfCartesianChart(
            key: _cartesianChartKey,
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
            zoomPanBehavior: _zoomPanBehavior,
          );
        }),
      ),
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

  Future<List<int>> _readImageData() async {
    final ui.Image data =
        await _cartesianChartKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<void> _renderPDF() async {
    final List<int> imageBytes = await _readImageData();
    final PdfBitmap bitmap = PdfBitmap(imageBytes);
    final PdfDocument document = PdfDocument();
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(
        bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    await FileSaveHelper.saveAndLaunchFile(
        document.save(), 'cartesian_chart.pdf');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      duration: Duration(milliseconds: 2000),
      content: Text('Chart has been exported as PDF document.'),
    ));
  }
}

class LiveData {
  LiveData(this.time, this.value);
  final int time;
  final num value;
}
