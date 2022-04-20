import 'package:first_flutter_project/Services/firestore_services.dart';
import 'package:first_flutter_project/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import 'welcome_page.dart';
import '../Custm_Widgets/verify_email_alert.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  State<Register> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<Register> {
  final Authentication _auth = Authentication();
  final Storage _photostorage = Storage();
  final UserDataStorage _storage = UserDataStorage();
  final _emailtext = TextEditingController();
  final _passwordtext = TextEditingController();
  final _nametext = TextEditingController();
  final _lastnametext = TextEditingController();
  bool _visibile = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    String description =
        'A Verification Email Has been sent! Please check your inbox';
    return _isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/default_profile_picture.jpg'),
                          radius: 70.0,
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
                              style:
                                  TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _auth
                                  .createUserWithEmailandPassword(
                                      _emailtext.text.trim(),
                                      _passwordtext.text.trim())
                                  .then((_) async {
                                UserData _userData = UserData(
                                    userEmail: _emailtext.text.trim(),
                                    userName: _nametext.text.trim(),
                                    userLastName: _lastnametext.text.trim());
                                await _storage.storeUserData(_userData);
                                _auth.sendEmailVerification();
                                debugPrint('Registration successfull');
                                if (!_auth.emailverified()) {
                                  description =
                                      'Email Not verified! Please check your email';
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => CustmAlertDialog(
                                        title: 'Email Verification',
                                        description: description,
                                        image: 'assets/email_sent.gif'));
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                                debugPrint('Message3:' + error.toString());
                              });
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
          );
  }

  Future<String?> _uploadProfileImage() async {
    final String? url;
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      //url = _photostorage.profileImageStorage(result.path);
    }
  }
}
