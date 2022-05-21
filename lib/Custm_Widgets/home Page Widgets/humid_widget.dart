import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../temp_chart_portrait.dart';

class HumidWidget extends StatefulWidget {
  const HumidWidget({Key? key, required this.humidite}) : super(key: key);
  final num humidite;

  @override
  State<HumidWidget> createState() => _HumidWidgetState();
}

class _HumidWidgetState extends State<HumidWidget> {
  bool barIsSelected = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Humidité',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                width: 300,
                height: 300,
                child: barIsSelected
                    ? LiquidCircularProgressIndicator(
                        value: widget.humidite / 100,
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        backgroundColor: Colors.white,
                        borderColor: Colors.blue,
                        borderWidth: 3.0,
                        direction: Axis.vertical,
                        center: const Text("%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                      )
                    : const TempChart(
                        value: 'humidite',
                      ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 27),
            child: Text(
              '${widget.humidite} %',
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
