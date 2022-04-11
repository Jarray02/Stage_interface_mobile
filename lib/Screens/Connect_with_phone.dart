import 'package:flutter/material.dart';
import 'package:first_flutter_project/Screens/Register.dart';

class ConnectWithPhone extends StatelessWidget {
  const ConnectWithPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect with phone',
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
                      'Connect with your phone',
                      style: TextStyle(
                        fontSize: 25.0,
                        wordSpacing: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
                          'Connect',
                          style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                        ),
                        onPressed: () {}),
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
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
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
