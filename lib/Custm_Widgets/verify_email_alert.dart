import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/material.dart';
import '../Screens/home_page.dart';
import '../Services/auth_services.dart';
import 'dart:async';

class CustmAlertDialog extends StatefulWidget {
  const CustmAlertDialog(
      {Key? key, required title, required description, required image})
      : super(key: key);
  @override
  State<CustmAlertDialog> createState() => _MyCustmAlertDialogState();
}

class _MyCustmAlertDialogState extends State<CustmAlertDialog> {
  final Authentication _auth = Authentication();
  String title = 'Email Verification';
  String image = 'assets/email_sent.gif';
  String description =
      'A Verification Email Has been sent! Please check your inbox';
  String buttonText = 'Resend';
  Timer? timer1, timer2;
  bool _clickable = false;
  int count = 30;
  String counttext = '';

  @override
  void initState() {
    timer1 = Timer.periodic(const Duration(seconds: 3), (timer) {
      _auth.emailverified();
    });

    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count--;
        if (count <= 0) {
          count = 0;
          _clickable = true;
          counttext = '';
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_auth.emailverified()) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: dialogContent(context),
      );
    } else {
      return const HomePage();
    }
  }

  Widget dialogContent(BuildContext context) {
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
            Center(
                child: Text(description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0))),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: _clickable
                          ? MaterialStateProperty.all<Color>(Colors.blue)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                      textStyle: _clickable
                          ? MaterialStateProperty.all<TextStyle>(
                              const TextStyle(color: Colors.white))
                          : MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.grey.shade500)),
                    ),
                    child: Text('$buttonText $counttext'),
                    onPressed: () {
                      _clickable
                          ? {
                              _auth.sendEmailVerification(),
                              _clickable = false,
                              count = 30
                            }
                          : counttext = '$count';
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
              backgroundImage: AssetImage(image),
            ),
          ),
        ),
      ],
    );
  }
}
