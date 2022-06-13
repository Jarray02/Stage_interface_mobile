import 'package:flutter/material.dart';

import '../../Services/auth_services.dart';

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Password',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyUpdatePassword(title: 'Update Password'),
    );
  }
}

class MyUpdatePassword extends StatefulWidget {
  const MyUpdatePassword({Key? key, required title}) : super(key: key);

  @override
  State<MyUpdatePassword> createState() => _MyUpdatePasswordState();
}

class _MyUpdatePasswordState extends State<MyUpdatePassword> {
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
  final _newpasswordtext = TextEditingController();
  final Authentication _auth = Authentication();
  bool _visibile = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('update your password'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
        ),
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
                        'Update your password',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
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
                          hintText: 'Enter your password',
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
                      const SizedBox(height: 15.0),
                      TextField(
                        controller: _newpasswordtext,
                        obscureText: _visibile,
                        decoration: InputDecoration(
                          hintText: 'Enter your new password',
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
                          fixedSize: MaterialStateProperty.all(
                              const Size(300.0, 50.0)),
                        ),
                        onPressed: () async {
                          await _auth
                              .updateUserPassword(context, _emailtext.text,
                                  _passwordtext.text, _newpasswordtext.text)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Password Updated Successfully')));
                          });
                        },
                        child: const Text(
                          'Update Password',
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
      ),
    );
  }
}
