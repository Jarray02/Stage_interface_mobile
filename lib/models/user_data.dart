import 'package:meta/meta.dart';

@immutable
class UserData {
  const UserData({
    this.userName,
    this.userLastName,
    required this.userEmail,
    this.userProfilePicture,
  });
  final String? userName;
  final String? userLastName;
  final String userEmail;
  final String? userProfilePicture;

  factory UserData.fromRTDB(Map<String, dynamic> data) {
    return UserData(
        userName: data['name'],
        userLastName: data['lastName'],
        userEmail: data['email'],
        userProfilePicture: data['photoURL']);
  }
}
