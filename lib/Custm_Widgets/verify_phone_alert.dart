import 'package:flutter/material.dart';
import '../Screens/homePage.dart';

class PhoneAlertDialog extends StatefulWidget {
  const PhoneAlertDialog({Key? key}) : super(key: key);

  @override
  State<PhoneAlertDialog> createState() => _PhoneAlertDialogState();
}

class _PhoneAlertDialogState extends State<PhoneAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(),
    );
  }
}
