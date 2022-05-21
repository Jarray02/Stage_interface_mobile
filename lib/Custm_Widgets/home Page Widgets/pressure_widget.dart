import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../custm_widgets.dart';

class PressureWidget extends StatefulWidget {
  const PressureWidget({Key? key, required this.pression}) : super(key: key);

  final num pression;

  @override
  State<PressureWidget> createState() => _PressureWidgetState();
}

class _PressureWidgetState extends State<PressureWidget> {
  bool barIsSelected = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Pression',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: barIsSelected
                  ? FAProgressBar(
                      progressColor: Colors.blue,
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      size: 100,
                      currentValue:
                          double.parse(widget.pression.toStringAsFixed(2)),
                      changeProgressColor: Colors.red,
                      maxValue: 5000,
                      displayText: '°C',
                      borderRadius: BorderRadius.circular(16),
                      animatedDuration: const Duration(milliseconds: 500),
                    )
                  : const TempChart(value: 'pression'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '${widget.pression} mPa',
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
