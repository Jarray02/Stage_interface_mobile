import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_project/Screens/home_page.dart';
import 'package:first_flutter_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddNewProfile extends StatefulWidget {
  const AddNewProfile({Key? key}) : super(key: key);

  @override
  State<AddNewProfile> createState() => _AddNewProfileState();
}

class _AddNewProfileState extends State<AddNewProfile> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final _profileName = TextEditingController();
  final _profileId = TextEditingController();
  final _profileMaxTemp = TextEditingController();
  final _profileMaxHumid = TextEditingController();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _isLoading = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlDownload = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add new profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          leading: IconButton(
            onPressed: () {
              //TODO: TEST
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => const MyHomePage()));
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: _isLoading
            ? const SafeArea(
                child:
                    Scaffold(body: Center(child: CircularProgressIndicator())))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
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
                                'Add new profile',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  wordSpacing: 2.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: _profileName,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new profile name',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.thermostat,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: _profileId,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new profile id',
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
                                controller: _profileMaxTemp,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new profile maximum temp',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.speed,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              TextField(
                                controller: _profileMaxHumid,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new profile max humidity',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.water,
                                    color: Colors.amber,
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
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 20.0, letterSpacing: 1.0),
                                  ),
                                  onPressed: () async {
                                    if (_verifyTextField(
                                        context,
                                        _profileName.text.trim(),
                                        _profileId.text.trim(),
                                        _profileMaxTemp.text.trim(),
                                        _profileMaxHumid.text.trim(),
                                        pickedFile)) {
                                      _isLoading = true;
                                      await uploadFile();
                                      Profile _newProfileData = Profile(
                                        name: _profileName.text.trim(),
                                        id: int.parse(_profileId.text.trim()),
                                        maxTemp: double.parse(
                                            _profileMaxTemp.text.trim()),
                                        maxHumid: double.parse(
                                            _profileMaxHumid.text.trim()),
                                        icon: const AssetImage(
                                            'assets/banane.png'),
                                      );
                                      await _uploadNewProfile(_newProfileData)
                                          .then((value) => Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyHomePage())));
                                    }
                                  }),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  bool _verifyTextField(
    BuildContext context,
    String? name,
    String? id,
    String? maxTemp,
    String? maxHumid,
    PlatformFile? file,
  ) {
    if (name!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid name')));
      return false;
    } else if (id!.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please put a valid id')));
      return false;
    } else if (maxTemp!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid temperature')));
      return false;
    } else if (maxHumid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please put a valid humidity')));
      return false;
    } else if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
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

  Future<void> _uploadNewProfile(Profile profile) async {
    try {
      await _ref.child('profile').child(profile.name.toLowerCase()).set({
        "name": profile.name.toLowerCase(),
        "id": profile.id,
        "maxTemp": profile.maxTemp,
        "maxHumid": profile.maxHumid,
        "icon": urlDownload,
      });
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
    }
  }
}
