import 'package:flutter/material.dart';
import 'package:first_flutter_project/Custm_Widgets/custm_CircularProgressIndicator.dart';

class CustmAlertDialog extends StatelessWidget {
  final String title, description;

  CustmAlertDialog({required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext contex) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(description, style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.bottomCenter,
              child: MyCustmProgressIndicator(),
            ),
          ]),
        ),
        const Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 50,
            backgroundImage: AssetImage('assets/email_sent.gif'),
          ),
        ),
      ],
    );
  }
}
