import 'package:first_flutter_project/Screens/Settings/update_email.dart';
import 'package:first_flutter_project/Screens/Settings/update_password.dart';
import 'package:first_flutter_project/Screens/welcome_page.dart';
import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Settings',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySettings(title: 'Settings'),
        routes: {
          'update_email': (context) => const UpdateEmail(),
          'update_password': (context) => const UpdatePassword()
        });
  }
}

class MySettings extends StatefulWidget {
  const MySettings({Key? key, required title}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  final Authentication _auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        elevation: 5.0,
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 50.0),
          const Center(
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'), radius: 70.0),
          ),
          const Divider(height: 45.0, color: Colors.blue),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.blue),
              const SizedBox(width: 2.0),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UpdateEmail()));
                  },
                  child: const Text('Update your email',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0))),
            ],
          ),
          const Divider(height: 3.0, color: Colors.blue),
          Row(
            children: [
              const Icon(Icons.lock, color: Colors.blue),
              const SizedBox(width: 2.0),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UpdatePassword()));
                  },
                  child: const Text('Update your password',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0))),
            ],
          ),
          const Divider(height: 3.0, color: Colors.blue),
          Row(
            children: [
              const Icon(Icons.delete, color: Colors.blue),
              const SizedBox(width: 2.0),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    _auth.deleteUserAccount().then((_) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomePage()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Account deleted successfully')));
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(error.toString())));
                                    });
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop;
                                    },
                                    child: const Text('Cancel'))
                              ],
                            ));
                  },
                  child: const Text('Delete your account',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0))),
            ],
          ),
          const Divider(height: 20.0, color: Colors.blue),
          Center(
              child: Image.asset('assets/settings.gif',
                  width: 250.0, height: 250.0)),
        ]),
      ),
    );
  }
}
