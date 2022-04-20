import 'package:first_flutter_project/Screens/Messages/messages.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const MyProfileSettings(title: 'Profile Settings'),
    );
  }
}

class MyProfileSettings extends StatefulWidget {
  const MyProfileSettings({Key? key, required title}) : super(key: key);

  @override
  State<MyProfileSettings> createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<MyProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MessagesPage()));
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
              onPressed: () {}, child: const Text('Delete your account')),
        ]),
      ),
    );
  }
}
