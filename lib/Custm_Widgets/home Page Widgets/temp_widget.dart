import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../custm_widgets.dart';

class TempWidget extends StatefulWidget {
  const TempWidget({Key? key, required this.temperature}) : super(key: key);
  final num temperature;

  @override
  State<TempWidget> createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  bool barIsSelected = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Temperature',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: barIsSelected
                  ? FAProgressBar(
                      progressColor: Colors.blue,
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      size: 100,
                      currentValue:
                          double.parse(widget.temperature.toStringAsFixed(2)),
                      changeProgressColor: Colors.red,
                      maxValue: 100,
                      displayText: '°C',
                      borderRadius: BorderRadius.circular(16),
                      animatedDuration: const Duration(milliseconds: 500),
                    )
                  : const TempChart(value: 'temperature'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '${widget.temperature} °C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          slectedView(),
        ],
      ),
    );
  }

  Widget slectedView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              if (!barIsSelected) {
                setState(() {
                  barIsSelected = true;
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: barIsSelected
                    ? MaterialStateProperty.all<Color>(Colors.blue)
                    : MaterialStateProperty.all<Color>(Colors.white)),
            child: Text(
              'Bar',
              style:
                  TextStyle(color: barIsSelected ? Colors.white : Colors.blue),
            ),
          ),
          const SizedBox(width: 5),
          OutlinedButton(
            onPressed: () {
              if (barIsSelected) {
                setState(() {
                  barIsSelected = false;
                });
              }
            },
            child: Text(
              'Graphe',
              style:
                  TextStyle(color: barIsSelected ? Colors.blue : Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: barIsSelected
                    ? MaterialStateProperty.all<Color>(Colors.white)
                    : MaterialStateProperty.all<Color>(Colors.blue)),
          ),
        ],
      ),
    );
  }
}
