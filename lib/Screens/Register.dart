// ignore: file_names
import 'package:first_flutter_project/Screens/HomePage.dart';
import 'package:first_flutter_project/Screens/WelcomPage.dart';
import 'package:first_flutter_project/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/Custm_Widgets/User.dart';
import 'package:first_flutter_project/Custm_Widgets/custm_alert_dialog.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyRegisterPage(title: 'Flutter Demo Home Page'),
      routes: {
        '/HomePage': (context) => const MyHomePage(),
      },
    );
  }
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  @override
  Widget build(BuildContext context) {
    final Authentication _auth = Authentication();
    final _emailtext = TextEditingController();
    final _passwordtext = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                      'Register',
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
                        hintText: 'Enter your phone',
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
                      decoration: const InputDecoration(
                        hintText: '***********',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        suffixIcon: Icon(Icons.lock, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            alignment: Alignment.center,
                            fixedSize: MaterialStateProperty.all(
                                const Size(300.0, 50.0))),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                        ),
                        onPressed: () async {
                          _auth.CreateUserWithEmailandPassword(
                                  _emailtext.text.trim(),
                                  _passwordtext.text.trim())
                              .whenComplete(() async {
                            showDialog(
                                context: context,
                                builder: (context) => CustmAlertDialog(
                                    title: 'Verification',
                                    description:
                                        'A Verification Email Has been sent! Please check your inbox'));
                            Users user = Users(
                                email: _emailtext.text.trim(),
                                password: _passwordtext.text.trim(),
                                phoneNumber: null);
                            Navigator.of(context).pop;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyHomePage()));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
                          });
                        }),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                },
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(fontSize: 15.0, letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
