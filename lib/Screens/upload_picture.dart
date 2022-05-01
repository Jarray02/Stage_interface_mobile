import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({Key? key}) : super(key: key);

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

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

    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload your profile picture'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(children: [
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.blue[100],
                  child: Image.file(File(pickedFile!.path!),
                      width: double.infinity, fit: BoxFit.cover),
                ),
              ),
            TextButton(
                onPressed: () async {
                  await selecFile();
                },
                child: const Text('Upload your profile picture')),
            ElevatedButton(
                onPressed: () {
                  uploadFile();
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.upload,
                      color: Colors.amber,
                    ),
                    Text('upload'),
                  ],
                )),
            buildProgress(),
          ]),
        ));
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.blue,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ));
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}
