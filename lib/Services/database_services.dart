import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref("/Data");

  //Write data to the Real Time Data Base (Firebase RTDB)
  Future<void> writeData() async {
    try {
      await ref.set({
        "name": "John",
        "age": 18,
        "address": {"line1": "100 Mountain View"}
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //Listen to Values changes in a specific child in the Real Time Database
  Future<Object?> listenToValueChanges(String path) async {
    Object? data;
    ref.child(path).onValue.listen((DatabaseEvent event) {
      data = event.snapshot.value;
    });
    return data;
  }
}
