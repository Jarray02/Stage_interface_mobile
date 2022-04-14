import 'package:first_flutter_project/Screens/connect_with_email.dart';
import 'package:first_flutter_project/Screens/connect_with_phone.dart';
import 'package:first_flutter_project/Screens/register.dart';
import 'package:first_flutter_project/Screens/welcome_page.dart';
import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

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
              const Center(
                child: CircleAvatar(
                  foregroundImage: AssetImage('assets/logo.png'),
                  radius: 80.0,
                ),
              ),
              const SizedBox(height: 60.0),
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
                    await _auth.signOut();
                    selectedItem(context, 4);
                  } catch (error) {
                    print(error.toString());
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
          builder: (context) => const ConnectWithEmail(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ConnectWithPhone(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Register(),
        ));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const WelcomePage()));
        break;
    }
  }
}
