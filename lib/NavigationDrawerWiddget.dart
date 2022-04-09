import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 48.0),
            buildMenuItem(text: 'First Menu', icon: Icons.person),
            const Divider(height: 5.0, color: Colors.white),
            buildMenuItem(text: 'Second Menu', icon: Icons.email),
            const Divider(height: 5.0, color: Colors.white),
            buildMenuItem(text: 'Third Menu', icon: Icons.exit_to_app),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    const color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      onTap: () {},
    );
  }
}
