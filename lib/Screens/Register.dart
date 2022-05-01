import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_project/Services/firestore_services.dart';
import 'package:first_flutter_project/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import 'screens.dart';
import '../Custm_Widgets/verify_email_alert.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: MyRegisterPage());
  }
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final Authentication _auth = Authentication();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('Users');
  final Storage _photostorage = Storage();
  final UserDataStorage _storage = UserDataStorage();
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
  final _nametext = TextEditingController();
  final _lastnametext = TextEditingController();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _visibile = false;
  bool _isLoading = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlDownload = '';

  @override
  Widget build(BuildContext context) {
    String description =
        'A Verification Email Has been sent! Please check your inbox';
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (pickedFile == null)
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/default_profile_picture.jpg'),
                                radius: 70.0,
                              ),
                            if (pickedFile != null)
                              Flexible(
                                child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.blue[100],
                                    child: Image.file(File(pickedFile!.path!))),
                              ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: FloatingActionButton(
                                  backgroundColor: Colors.transparent,
                                  onPressed: () async {
                                    await selecFile();
                                  },
                                  elevation: 0.0,
                                  mini: true,
                                  child: const Icon(Icons.camera_alt)),
                            ),
                            const Divider(height: 45.0),
                            const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 25.0,
                                wordSpacing: 2.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _emailtext,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.email,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _nametext,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.abc,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _lastnametext,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter your last name',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.abc,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            TextField(
                              controller: _passwordtext,
                              obscureText: !_visibile,
                              decoration: InputDecoration(
                                hintText:
                                    'Enter your password (must be at least 6 digits)',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _visibile = !_visibile;
                                    });
                                  },
                                  icon: _visibile
                                      ? const Icon(Icons.visibility,
                                          color: Colors.amber)
                                      : const Icon(Icons.visibility_off,
                                          color: Colors.amber),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                                style: ButtonStyle(
                                    alignment: Alignment.center,
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(300.0, 50.0))),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 20.0, letterSpacing: 1.0),
                                ),
                                onPressed: () async {
                                  if (_verifyTextField(
                                      context,
                                      _emailtext.text.trim(),
                                      _nametext.text.trim(),
                                      _lastnametext.text.trim(),
                                      _passwordtext.text.trim())) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await _auth
                                        .createUserWithEmailandPassword(
                                            context,
                                            _emailtext.text.trim(),
                                            _passwordtext.text.trim())
                                        .then((_) async {
                                      await _auth.sendEmailVerification();
                                      await uploadFile();
                                      UserData _userData = UserData(
                                          userEmail: _emailtext.text.trim(),
                                          userName: _nametext.text.trim(),
                                          userLastName:
                                              _lastnametext.text.trim(),
                                          userProfilePicture: urlDownload);
                                      await _uploadUserData(_userData);
                                      debugPrint('Registration successfull');
                                      if (!_auth.emailverified()) {
                                        description =
                                            'Email Not verified! Please check your email';
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustmAlertDialog(
                                                  title: 'Email Verification',
                                                  description: description,
                                                  image:
                                                      'assets/email_sent.gif'));
                                    });
                                  }
                                }),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          dispose();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Log in",
                          style: TextStyle(fontSize: 15.0, letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  bool _verifyTextField(BuildContext context, String? email, String? name,
      String? lastname, String? password) {
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid email')));
      return false;
    } else if (name == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid name')));
      return false;
    } else if (lastname == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid last name')));
      return false;
    } else if (password == null || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid password')));
      return false;
    } else {
      return true;
    }
  }

  Future selecFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'profile_images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });
  }

  Future<void> _uploadUserData(UserData userData) async {
    try {
      await _ref.child(FirebaseAuth.instance.currentUser!.uid).set({
        "email": userData.userEmail,
        "name": userData.userName,
        "lastName": userData.userLastName,
        "photoURL": userData.userProfilePicture
      });
    } on firebase_storage.FirebaseException catch (error) {
      debugPrint(error.toString());
    }
  }

  // Future<String?> _uploadProfileImage() async {
  //   String? url;
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );
  //   if (result != null) {
  //     await _photostorage
  //         .uploadProfileImage(result.path, result.name)
  //         .then((value) {
  //       url = value;
  //     });
  //   }
  //   return url;
  // }

  // Future<String?> _getDefaultProfilePicture() async {
  //   String? url;
  //   try {
  //     url = await storage
  //         .ref('/profile_images/default_profile_picture.jpg')
  //         .getDownloadURL();
  //   } on firebase_storage.FirebaseException catch (error) {
  //     debugPrint('error uploading profile picture ${error.toString()}');
  //   }
  //   return url;
  // }
}
