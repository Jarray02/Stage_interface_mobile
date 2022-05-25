import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadProfileImage(String filePath, String fileName) async {
    File file = File(filePath);
    String? url;
    try {
      await storage.ref('/profile_images').putFile(file);
      url = await storage.ref().getDownloadURL();
    } on firebase_storage.FirebaseException catch (error) {
      debugPrint('error uploading profile picture ${error.toString()}');
    }
    return url;
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('/profile_images').listAll();

    for (var ref in results.items) {
      debugPrint('Found file : $ref');
    }
    return results;
  }
}
