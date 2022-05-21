import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_project/Services/services.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'screens.dart';
import '../Custm_Widgets/verify_email_alert.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<Register> {
  final Authentication _auth = Authentication();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('Users');
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
        ? const SafeArea(
            child: Scaffold(body: Center(child: CircularProgressIndicator())))
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (pickedFile == null)
                              CircleAvatar(
                                backgroundImage: const AssetImage(
                                    'assets/default_profile_picture.jpg'),
                                radius: 70.0,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton.extended(
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      onPressed: () async {
                                        selecFile();
                                      },
                                      label: const Icon(Icons.camera_alt)),
                                ),
                              ),
                            if (pickedFile != null)
                              CircleAvatar(
                                backgroundImage:
                                    Image.file(File(pickedFile!.path!)).image,
                                backgroundColor: Colors.transparent,
                                radius: 70,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton.extended(
                                      elevation: 0.0,
                                      backgroundColor: Colors.transparent,
                                      onPressed: () async {
                                        selecFile();
                                      },
                                      label: const Icon(Icons.camera_alt)),
                                ),
                              ),
                            const Divider(height: 25.0),
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
                                      _passwordtext.text.trim(),
                                      pickedFile)) {
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
      String? lastname, String? password, PlatformFile? file) {
    if (email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid email')));
      return false;
    } else if (name!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid name')));
      return false;
    } else if (lastname!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid last name')));
      return false;
    } else if (password!.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid password')));
      return false;
    } else if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('please select an image')));
      return false;
    } else {
      return true;
    }
  }

  Future selecFile() async {
    final result = await FilePicker.platform.pickFiles();
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
}
