// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

class Responsive extends StatelessWidget {
  Widget? mobile;
  final Widget desktop;
  Responsive({
    Key? key,
    this.mobile,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        } else if (mobile != null) {
          return mobile!;
        } else {
          return desktop;
        }
      }),
    );
  }
}
