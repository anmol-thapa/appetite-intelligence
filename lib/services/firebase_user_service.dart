import 'dart:async';

import 'package:appetite_intelligence/models/user_model.dart';
import 'package:appetite_intelligence/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A custom stream provider that emitts [UserModel] if
/// 1. Firebase auth emits a valid user
/// AND
/// 2. Firestore contains a doc with the user's UID as the name within 2 seconds of creating the user
///
/// If either condition is not met `null` will emitted.
/// This ensures that the app only considers a user as logged in
/// if both authenticiation and profile data are present
///
/// Used by [GoRouter] to control app-level routing
final firebaseUser = StreamProvider<UserModel?>((ref) {
  final controller = StreamController<UserModel?>();
  StreamSubscription<DocumentSnapshot>? docSub;
  // Ensures delay does not invalidate a properly logged in user
  bool hasEmittedUser = false;
  bool docWasPresentBefore = false;

  final authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
    // Consider the current document as stale
    docSub?.cancel();

    // Firebase auth takes priority
    if (user == null) {
      controller.add(null);
      return;
    }

    docSub = DatabaseService.db
        .collection('Users')
        .doc(user.uid)
        .snapshots()
        .listen((doc) async {
          final stillLoggedIn =
              FirebaseAuth.instance.currentUser?.uid == user.uid;

          if (!stillLoggedIn) {
            controller.add(null);
            return;
          }

          if (doc.exists) {
            hasEmittedUser = true;
            docWasPresentBefore = true;
            controller.add(UserModel.fromMap(doc.data()!));
            return;
          }
          // If the doc doesn't currently exist but used to, assume it to be deleted
          if (docWasPresentBefore) {
            controller.add(null);
            return;
          }
          // FirebaseAuth.instance.signOut();
          // Waits for doc to potentially load
          Future.delayed(const Duration(seconds: 4)).then((_) {
            final stillLoggedIn =
                FirebaseAuth.instance.currentUser?.uid == user.uid;
            if (!hasEmittedUser && controller.hasListener && stillLoggedIn) {
              controller.add(null);
            }
          });
        });
  });

  ref.onDispose(() {
    authSub.cancel();
    docSub?.cancel();
    controller.close();
  });

  return controller.stream;
});
