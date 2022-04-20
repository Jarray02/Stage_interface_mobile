import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/screens.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;

  //sign in with email & password
  Future signInWithEmailandPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage())));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ConnectWithEmail()));
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ConnectWithEmail()));
      }
    }
  }

  //Create user with email & password
  Future createUserWithEmailandPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Register()));
      } else if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Register()));
      }
    }
  }

  //Create user with phone number

  //sign out
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  //Delete users account
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'The user must reauthenticate before this operation can be executed.')));
      }
    }
  }

  //Update user email (this method requires the user to have recently signed in)
  Future<void> updateUserEmail(BuildContext context, String email,
      String newEmail, String password) async {
    AuthCredential userCredential =
        EmailAuthProvider.credential(email: email, password: password);

    await _auth.currentUser!
        .reauthenticateWithCredential(userCredential)
        .then((userCredential) {
      userCredential.user!.updateEmail(newEmail);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  //Update user password (this method requires the user to have recently signed in)
  Future<void> updateUserPassword(BuildContext context, String email,
      String password, String newPassword) async {
    AuthCredential userCredential =
        EmailAuthProvider.credential(email: email, password: password);

    await _auth.currentUser!
        .reauthenticateWithCredential(userCredential)
        .then((userCredential) {
      userCredential.user!.updatePassword(newPassword);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  // //Phone number verification
  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   PhoneVerificationCompleted verificationCompleted =
  //       (PhoneAuthCredential phoneAuthCredential) async {};
  //   PhoneVerificationFailed verificationFailed = (FirebaseAuthException) {};
  //   PhoneCodeSent codeSent =
  //       (String verificaitonID, [int? forceResendingtoken]) {};
  //   PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
  //       (String verificaitonID) {};
  //   try {
  //     await _auth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         verificationCompleted: verificationCompleted,
  //         verificationFailed: verificationFailed,
  //         codeSent: codeSent,
  //         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   }
  // }

  bool emailverified() {
    User? user = _auth.currentUser;
    if (user != null) {
      user.reload();
      if (user.emailVerified) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //Send verification email
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //Listen to users current authentication state (i.e Currently logged in or not)
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
