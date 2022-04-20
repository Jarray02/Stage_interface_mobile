import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_project/models/models.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class UserDataStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserData(UserData userData) async {
    await _firestore.collection('users').doc(userData.userName).set({
      "userName": userData.userName,
      "userLastName": userData.userLastName,
      "userEmail": userData.userEmail,
      "userProfilePicture": userData.userProfilePicture
    });
  }
}
