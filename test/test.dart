import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = FirebaseAuth.instance;

  try {
    await user.createUserWithEmailAndPassword(
      email: "email@email.com",
      password: "password",
    );
    print(user.currentUser?.uid);
  } on FirebaseAuthException catch (err) {
    print(err);
  }
}
