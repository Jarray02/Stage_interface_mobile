import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Services/services.dart';
import '../screens.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings(
      {Key? key,
      required this.userPic,
      this.userName,
      this.userLastName,
      this.userEmail})
      : super(key: key);

  final String userPic;
  final String? userName;
  final String? userLastName;
  final String? userEmail;

  @override
  State<ProfileSettings> createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<ProfileSettings> {
  final Authentication _auth = Authentication();
  final auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('Users');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          leading: IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                //TODO : TEST
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => const MyHomePage()));
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          title: const Text(
            'Profile Settings',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 5.0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          CachedNetworkImageProvider(widget.userPic),
                      radius: 70.0),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text('Update your profile picture')),
                const Divider(color: Colors.blue, height: 2.0),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Email'),
                            const SizedBox(width: 10),
                            Text(widget.userEmail!),
                          ],
                        ),
                        const Divider(color: Colors.blue, height: 2.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Name'),
                            const SizedBox(width: 10),
                            Text(widget.userName!),
                          ],
                        ),
                        const Divider(color: Colors.blue, height: 2.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Last Name'),
                            const SizedBox(width: 10),
                            Text(widget.userLastName!),
                          ],
                        ),
                      ],
                    )),
                const Divider(color: Colors.blue, height: 2.0),
                TextButton(
                    onPressed: () async {
                      await _ref.child(auth.currentUser!.uid).remove();
                      await _auth.deleteUserAccount(context).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ConnectWithEmail()));
                      });
                    },
                    child: const Text('Delete your account')),
              ]),
        ),
      ),
    );
  }
}
