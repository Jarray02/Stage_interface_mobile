import 'package:first_flutter_project/Custm_Widgets/custm_widgets.dart';
import 'package:first_flutter_project/Services/auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';

// This widget is the root of our application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDHjow2ol3uJUd9cXoYFD27IbLOabve4g0',
        authDomain: 'projet-stage-b2fc8.firebaseapp.com',
        databaseURL: 'https://projet-stage-b2fc8-default-rtdb.firebaseio.com',
        projectId: 'projet-stage-b2fc8',
        storageBucket: 'projet-stage-b2fc8.appspot.com',
        messagingSenderId: '125736760135',
        appId: '1:125736760135:web:792c7902543f869c779262',
        measurementId: 'G-9DN8JT9MJQ',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: Authentication().user,
      initialData: null,
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        title: 'Main',
        home: const Wrapper(),
      ),
    );
  }
}
