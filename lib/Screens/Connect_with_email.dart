import 'package:first_flutter_project/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/Screens/Register.dart';

class ConnectWithEmail extends StatelessWidget {
  const ConnectWithEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect with email',
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
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
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
                      'Connect with your email',
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
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
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
                        await _auth.SignInWithEmailandPassword(
                                _emailtext.text.trim(),
                                _passwordtext.text.trim())
                            .whenComplete(() {
                          Navigator.of(context).pop;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())));
                        });
                      },
                      child: const Text(
                        'Connect',
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
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Register()));
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
