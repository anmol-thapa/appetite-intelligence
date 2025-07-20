import 'dart:convert';
import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/services/onboarding_service.dart';
import 'package:appetite_intelligence/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUser(UserModel userModel) async {
    final encodedUserModel = jsonEncode(userModel.toMap());

    final response = await http.post(
      Uri.parse(KMethodUrl.addUserURL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userModel": encodedUserModel,
        "uid": FirebaseAuth.instance.currentUser!.uid,
      }),
    );

    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<String?> signUp(OnboardingService onboarding) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: onboarding.email!,
        password: onboarding.password!,
      );

      final userModel = UserModel.create(
        email: onboarding.email!,
        name: onboarding.name!,
        age: onboarding.age!,
        height: onboarding.height!,
        weight: onboarding.weight!,
        macroGoals: onboarding.macroGoals!,
        cheatMeals: onboarding.cheatDays!,
      );

      await addUser(userModel);
      await cred.user?.sendEmailVerification();
      return null;
    } catch (err) {
      if (_auth.currentUser != null) await _auth.currentUser!.delete();
      return err.toString();
    }
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  static String? validateName(String name) {
    name = name.trim();

    if (name.length < 2) {
      return 'Name must be at least 2 characters long!';
    } else if (name.length > 15) {
      return 'Name must be less than 15 characters long!';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (!isEmail(email)) {
      return 'The email is not valid.';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 6 || !isAscii(password)) {
      return 'The password must be at least 6 characters long and use only ASCII characters.';
    }
    return null;
  }
}
