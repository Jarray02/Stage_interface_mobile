import 'package:flutter/material.dart';
import 'package:first_flutter_project/main.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/main': (context) => const HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void _FirebaseRegistration() {}

class _MyHomePageState extends State<MyHomePage> {
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
                    'Register',
                    style: TextStyle(
                      fontSize: 25.0,
                      wordSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.phone,
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              child: const Text(
                'Already have an account? Log in',
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
