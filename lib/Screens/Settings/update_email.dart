import 'package:first_flutter_project/Custm_Widgets/custm_widgets.dart';
import 'package:flutter/material.dart';

import '../../Services/auth_services.dart';

class UpdateEmail extends StatelessWidget {
  const UpdateEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Email',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyUpdateEmail(title: 'Update Email'),
    );
  }
}

class MyUpdateEmail extends StatefulWidget {
  const MyUpdateEmail({Key? key, required title}) : super(key: key);

  @override
  State<MyUpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<MyUpdateEmail> {
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
  final _newemail = TextEditingController();
  final Authentication _auth = Authentication();
  bool _visibile = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 95.0, 30.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.png'),
                      radius: 70.0,
                    ),
                    const Divider(height: 45.0),
                    const Text(
                      'Update your Email',
                      style: TextStyle(
                        fontSize: 25.0,
                        wordSpacing: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _emailtext,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: _newemail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your new email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: _passwordtext,
                      obscureText: _visibile,
                      decoration: InputDecoration(
                        hintText: '***********',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _visibile = !_visibile;
                            });
                          },
                          icon: _visibile
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.amber,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.amber,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        fixedSize:
                            MaterialStateProperty.all(const Size(300.0, 50.0)),
                      ),
                      onPressed: () async {
                        await _auth
                            .updateUserEmail(context, _emailtext.text,
                                _newemail.text, _passwordtext.text)
                            .then((_) {
                          showDialog(
                              context: context,
                              builder: (context) => const CustmAlertDialog(
                                  title: 'Email Verification',
                                  description:
                                      'Email Not verified! Please check your email',
                                  image: 'assets/email_sent.gif'));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Email Updated Successfully')));
                        });
                      },
                      child: const Text(
                        'Update email',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
