import 'package:first_flutter_project/Screens/connect_with_email.dart';
import 'package:first_flutter_project/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if ((user == null) || (!user.emailVerified)) {
      return const ConnectWithEmail();
    } else {
      return const HomePage();
    }
  }
}
