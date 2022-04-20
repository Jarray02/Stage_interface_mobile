import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadProfileImage(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('/profile_images').putFile(file);
    } on firebase_storage.FirebaseException catch (error) {
      debugPrint('error uploading profile picture ${error.toString()}');
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('/profile_images').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      debugPrint('Found file : $ref');
    });
    return results;
  }
}
