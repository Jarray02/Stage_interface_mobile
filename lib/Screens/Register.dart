import 'package:flutter/material.dart';
import 'homePage.dart';
import 'welcome_page.dart';
import '../Screens/homePage.dart';
import '../Custm_Widgets/verify_email_alert.dart';
import '../Services/auth_services.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyRegisterPage(title: 'Register Page'),
      routes: {
        '/homePage': (context) => const MyHomePage(),
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
  final Authentication _auth = Authentication();
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
  bool _visibile = true;
  @override
  Widget build(BuildContext context) {
    String description =
        'A Verification Email Has been sent! Please check your inbox';
    ;
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
                              ? const Icon(Icons.visibility,
                                  color: Colors.amber)
                              : const Icon(Icons.visibility_off,
                                  color: Colors.amber),
                        ),
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
                          await _auth
                              .createUserWithEmailandPassword(
                                  _emailtext.text.trim(),
                                  _passwordtext.text.trim())
                              .whenComplete(() async {
                            _auth.sendEmailVerification();
                            print('Registration successfull');
                            if (!_auth.emailverified()) {
                              description =
                                  'Email Not verified! Please check your email';
                            }
                            showDialog(
                                context: context,
                                builder: (context) => CustmAlertDialog(
                                    title: 'Email Verification',
                                    description: description,
                                    image: 'assets/email_sent.gif'));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
                            print('Message3:' + error.toString());
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
                  dispose();
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
