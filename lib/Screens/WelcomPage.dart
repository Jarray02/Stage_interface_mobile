// ignore: file_names
import 'package:flutter/material.dart';
import 'package:first_flutter_project/Screens/Connect_with_phone.dart';
import 'package:first_flutter_project/Screens/Connect_with_email.dart';
import 'package:first_flutter_project/Screens/Register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tropical Bio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWelcomePage(title: 'Tropical Bio'),
      routes: {
        '/Connect_with_phone': (context) => const ConnectWithPhone(),
        '/Connect_with_email': (context) => const ConnectWithEmail(),
        '/Register': (context) => const Register(),
      },
    );
  }
}

class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyWelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<MyWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 100.0,
              ),
              const Divider(height: 45.0),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(350.0, 45.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ConnectWithEmail()),
                  );
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.email_rounded,
                        color: Colors.amber[500],
                      ),
                      const SizedBox(width: 10.0),
                      const Text('Connect with email'),
                    ]),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(350.0, 45.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConnectWithPhone(),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: Colors.amber[500],
                    ),
                    const SizedBox(width: 10.0),
                    const Text('Connect with phone number')
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}