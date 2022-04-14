import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/material.dart';
import '../Screens/homePage.dart';
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
  Timer? timer;
  final Authentication _auth = Authentication();
  String title = 'Email Verification';
  String image = 'assets/email_sent.gif';
  String description =
      'A Verification Email Has been sent! Please check your inbox';

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _auth.emailverified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
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
      return const MyHomePage();
    }
  }

  dialogContent(BuildContext context) {
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
              child: ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  if (_auth.emailverified()) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
                  } else {
                    description = 'Email Not verified! Please check your email';
                  }
                },
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
