import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;

  //sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (error.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //sign in with phone number

  //Create user with email & password
  Future createUserWithEmailandPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  //Create user with phone number

  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  //Phone number verification
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {};
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException) {};
    PhoneCodeSent codeSent =
        (String verificaitonID, [int? forceResendingtoken]) {};
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificaitonID) {};
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (error) {
      print(error.toString());
    }
  }

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
