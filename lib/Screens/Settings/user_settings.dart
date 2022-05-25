import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_flutter_project/Screens/Settings/update_email.dart';
import 'package:first_flutter_project/Screens/Settings/update_password.dart';
import 'package:first_flutter_project/Screens/connect_with_email.dart';
import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key, required this.profilePic}) : super(key: key);

  final String profilePic;
  @override
  State<UserSettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<UserSettings> {
  final Authentication _auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 5.0,
        ),
        body: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                Center(
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          CachedNetworkImageProvider(widget.profilePic),
                      radius: 70.0),
                ),
                const SizedBox(height: 40.0),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.blue),
                    const SizedBox(width: 2.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UpdateEmail(),
                          ),
                        );
                      },
                      child: const Text(
                        'Update your email',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 3.0, color: Colors.blue),
                Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.blue),
                    const SizedBox(width: 2.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UpdatePassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Update your password',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
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
                                      child: const Text('Yes'),
                                      onPressed: () async {
                                        _auth
                                            .deleteUserAccount(context)
                                            .then((_) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ConnectWithEmail(),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Account deleted successfully'),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ));
                      },
                      child: const Text(
                        'Delete your account',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Image.asset('assets/settings.gif',
                      width: 250.0, height: 250.0),
                ),
              ]),
        ),
      ),
    );
  }
}
