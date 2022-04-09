import 'package:flutter/material.dart';
import 'package:first_flutter_project/Register.dart';

class ConnectWithEmail extends StatelessWidget {
  const ConnectWithEmail({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmailPgae(title: 'Connect with email'),
      routes: {
        '/Register': (context) => const Register(),
      },
    );
  }
}

class EmailPgae extends StatefulWidget {
  const EmailPgae({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EmailPgae> createState() => _MyEmailState();
}

class _MyEmailState extends State<EmailPgae> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60.0, 100.0, 60.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(height: 10.0),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'),
                    radius: 70.0,
                  ),
                  Divider(height: 45.0),
                  Text(
                    'Connect with your email',
                    style: TextStyle(
                      fontSize: 25.0,
                      wordSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                  SizedBox(height: 8.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '***********',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.lock,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Register');
              },
              child: const Text(
                "Don't have an account? Register",
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
