import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/Screens/screens.dart';
import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:first_flutter_project/models/models.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  String? _email, _username, _userlastname, _userprofilepic;

  getUserPicture() async {
    final event = await _ref
        .child('Users/${_auth.currentUser!.uid}')
        .once(DatabaseEventType.value);
    final data = event.snapshot.value;
    var userDataMap = Map<String, dynamic>.from(data as LinkedHashMap);

    final userdata = UserData.fromRTDB(userDataMap);
    setState(() {
      _email = userdata.userEmail;
      _username = userdata.userName;
      _userlastname = userdata.userLastName;
      _userprofilepic = userdata.userProfilePicture;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserPicture();
  }

  @override
  Widget build(BuildContext context) {
    final Authentication _auth = Authentication();
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_userprofilepic != null)
                      CircleAvatar(
                        foregroundImage: NetworkImage(_userprofilepic!),
                        radius: 80.0,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_username != null)
                      Text(_username!,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                  ]),
              const Divider(height: 40.0, color: Colors.white, thickness: 0.8),
              buildMenuItem(
                  text: 'Profile',
                  icon: Icons.person,
                  onPressed: () => selectedItem(context, 0)),
              const SizedBox(height: 10.0),
              buildMenuItem(
                  text: 'Notifications',
                  icon: Icons.notifications,
                  onPressed: () => selectedItem(context, 1)),
              const SizedBox(height: 10.0),
              buildMenuItem(
                  text: 'Messages',
                  icon: Icons.message,
                  onPressed: () => selectedItem(context, 2)),
              const Divider(height: 40.0, color: Colors.white, thickness: 0.8),
              buildMenuItem(
                text: 'Settings',
                icon: Icons.settings,
                onPressed: () => selectedItem(context, 3),
              ),
              const SizedBox(height: 10.0),
              buildMenuItem(
                text: 'Log out',
                icon: Icons.exit_to_app,
                onPressed: () async {
                  try {
                    await _auth.signOut(context);
                    selectedItem(context, 4);
                  } catch (error) {
                    debugPrint(error.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onPressed,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileSettings(userPic: _userprofilepic!),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ConnectWithPhone(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesPage(userPic: _userprofilepic!),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UserSettings(),
        ));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const WelcomePage()));
        break;
    }
  }
}
