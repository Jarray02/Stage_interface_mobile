import 'package:flutter/material.dart';

class MyCustmProgressIndicator extends StatefulWidget {
  const MyCustmProgressIndicator({Key? key}) : super(key: key);

  @override
  State<MyCustmProgressIndicator> createState() =>
      _MyCustmProgressIndicatorState();
}

class _MyCustmProgressIndicatorState extends State<MyCustmProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
    );
  }
}
