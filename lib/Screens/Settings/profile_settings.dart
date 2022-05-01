import 'package:flutter/material.dart';
import '../../Services/services.dart';
import '../screens.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key, required this.userPic}) : super(key: key);

  final String userPic;

  @override
  State<ProfileSettings> createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<ProfileSettings> {
  final Authentication _auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MessagesPage(userPic: widget.userPic)));
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text('Profile Settings'),
        elevation: 5.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        alignment: Alignment.center,
        child: Column(children: [
          TextButton(
              onPressed: () {},
              child: const Text('Update your profile picture')),
          const Divider(color: Colors.blue, height: 2.0),
          TextButton(onPressed: () {}, child: const Text('Update your name')),
          const Divider(color: Colors.blue, height: 2.0),
          TextButton(
              onPressed: () {}, child: const Text('Update your family name')),
          const Divider(color: Colors.blue, height: 2.0),
          TextButton(
              onPressed: () async {
                await _auth.deleteUserAccount(context).then((value) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const WelcomePage()));
                });
              },
              child: const Text('Delete your account')),
        ]),
      ),
    );
  }
}
