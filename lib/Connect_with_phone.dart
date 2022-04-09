import 'package:flutter/material.dart';
import 'package:first_flutter_project/Register.dart';

class ConnectWithPhone extends StatelessWidget {
  const ConnectWithPhone({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PhonePage(title: 'Connect with phone'),
      routes: {
        '/Register': (context) => const Register(),
      },
    );
  }
}

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PhonePage> createState() => _MyPhonePageState();
}

class _MyPhonePageState extends State<PhonePage> {
  bool _visibile = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 100.0, horizontal: 40.0),
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
                        'Connect with your phone',
                        style: TextStyle(
                          fontSize: 25.0,
                          wordSpacing: 2.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      const TextField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Enter your phone',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
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
                      const SizedBox(height: 12.0),
                      TextField(
                        obscureText: _visibile,
                        decoration: InputDecoration(
                          hintText: '***********',
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
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
                                    Icons.visibility,
                                    color: Colors.amber,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.amber,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
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
        ],
      ),
    );
  }
}
