import 'dart:async';

import 'package:appetite_intelligence/models/food_model.dart';
import 'package:appetite_intelligence/models/summary_model.dart';
import 'package:appetite_intelligence/services/database_service.dart';
import 'package:appetite_intelligence/services/date_service.dart';
import 'package:appetite_intelligence/services/firebase_user_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodService {
  static void updateSummaryRef(
    Transaction transaction,
    DocumentReference<Map<String, dynamic>> summaryRef,
    Map<String, dynamic> payload,
  ) {
    int mult = payload['mult'];
    FoodModel foodModel = payload['foodModel'];
    double servingsMultiplier = payload['servingsMultiplier'];
    String rating = payload['rating'];
    String mealRatingField = payload['mealRatingField'];
    String mealTimeCount = payload['mealTimeCount'];

    transaction.update(summaryRef, {
      'caloriesConsumed': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['calories']! * servingsMultiplier,
            ),
      ),
      'macroCount.fats': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['fats']! * servingsMultiplier,
            ),
      ),
      'macroCount.carbs': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['carbs']! * servingsMultiplier,
            ),
      ),
      'macroCount.protein': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['protein']! * servingsMultiplier,
            ),
      ),
      'mealRatingMacroCount.$rating.fats': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['fats']! * servingsMultiplier,
            ),
      ),
      'mealRatingMacroCount.$rating.carbs': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['carbs']! * servingsMultiplier,
            ),
      ),
      'mealRatingMacroCount.$rating.protein': FieldValue.increment(
        mult *
            Formatter.roundToInt(
              foodModel.nitrution['protein']! * servingsMultiplier,
            ),
      ),
      mealRatingField: FieldValue.increment(mult * 1),
      mealTimeCount: FieldValue.increment(mult * 1),
      'loggedFood': true,
    });
  }

  static Future<void> addFood(WidgetRef ref, FoodModel foodModel) async {
    final dateNotifier = ref.watch(dateSelectionProvider);
    String formattedDate = Formatter.dateFormat(
      date: dateNotifier.currentDateSelection,
    );

    final mealRef = DatabaseService.db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Logs')
        .doc(formattedDate)
        .collection('Meals');

    final summaryRef = mealRef.doc('summary');
    await DatabaseService.db.runTransaction((transaction) async {
      final summarySnap = await transaction.get(summaryRef);
      final mealDoc = mealRef.doc();
      transaction.set(mealDoc, foodModel.toMap());

      if (!summarySnap.exists) {
        transaction.set(summaryRef, await SummaryModel.defaultMap());
      }

      double servingSize = foodModel.serving['size'];
      int baseServingSize = foodModel.serving['base'];
      double servingsMultiplier = (servingSize / baseServingSize);

      String rating = foodModel.healthRating.name;
      String mealRatingField = 'mealRatingCount.$rating';
      String mealTimeCount = 'mealTimeCount.${foodModel.mealTime.name}';

      Map<String, dynamic> payload = {
        'mult': 1,
        'foodModel': foodModel,
        'servingsMultiplier': servingsMultiplier,
        'rating': rating,
        'mealRatingField': mealRatingField,
        'mealTimeCount': mealTimeCount,
      };

      updateSummaryRef(transaction, summaryRef, payload);
    });
  }

  static Future<void> deleteFood(WidgetRef ref, FoodModel foodModel) async {
    final dateNotifier = ref.watch(dateSelectionProvider);
    String formattedDate = Formatter.dateFormat(
      date: dateNotifier.currentDateSelection,
    );

    final mealRef = DatabaseService.db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Logs')
        .doc(formattedDate)
        .collection('Meals');

    final summaryRef = mealRef.doc('summary');
    final querySnap =
        await mealRef
            .where('loggedAt', isEqualTo: foodModel.loggedAt)
            .limit(1)
            .get();

    if (querySnap.docs.isEmpty) {
      return;
    }

    await DatabaseService.db.runTransaction((transaction) async {
      final summarySnap = await transaction.get(summaryRef);
      final mealDocRef = querySnap.docs.first.reference;
      transaction.delete(mealDocRef);

      if (!summarySnap.exists) {
        transaction.set(summaryRef, await SummaryModel.defaultMap());
      }

      double servingSize = foodModel.serving['size'];
      int baseServingSize = foodModel.serving['base'];
      double servingsMultiplier = (servingSize / baseServingSize);

      String rating = foodModel.healthRating.name;
      String mealRatingField = 'mealRatingCount.$rating';
      String mealTimeCount = 'mealTimeCount.${foodModel.mealTime.name}';

      Map<String, dynamic> payload = {
        'mult': -1,
        'foodModel': foodModel,
        'servingsMultiplier': servingsMultiplier,
        'rating': rating,
        'mealRatingField': mealRatingField,
        'mealTimeCount': mealTimeCount,
      };

      updateSummaryRef(transaction, summaryRef, payload);
    });
  }
}

final summarySnapProvider = StreamProvider<SummaryModel>((ref) {
  final userModel = ref.watch(firebaseUser).value;
  if (userModel == null) return Stream.empty();

  final dateNotifier = ref.watch(dateSelectionProvider);
  final controller = StreamController<SummaryModel>();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String formattedDate = Formatter.dateFormat(
    date: dateNotifier.currentDateSelection,
  );

  bool docWasPresentBefore = false;

  final mealsRef = DatabaseService.db
      .collection('Users')
      .doc(uid)
      .collection('Logs')
      .doc(formattedDate)
      .collection('Meals');

  final summarySub = mealsRef.doc('summary').snapshots().listen((doc) async {
    if (doc.exists) {
      controller.add(SummaryModel.fromMap(doc.data()!));
    } else {
      if (!docWasPresentBefore) {
        mealsRef.doc('summary').set(await SummaryModel.defaultMap());
        controller.add(await SummaryModel.defaultModel());
      }
    }
    docWasPresentBefore = true;
  });

  ref.onDispose(() {
    controller.close();
    summarySub.cancel();
  });

  return controller.stream;
});

final mealsProvider = StreamProvider<List<FoodModel>>((ref) {
  final userModel = ref.watch(firebaseUser).value;
  if (userModel == null) return Stream.empty();

  final dateNotifier = ref.watch(dateSelectionProvider);
  final controller = StreamController<List<FoodModel>>();
  String formattedDate = Formatter.dateFormat(
    date: dateNotifier.currentDateSelection,
  );
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final mealsSub = DatabaseService.db
      .collection('Users')
      .doc(uid)
      .collection('Logs')
      .doc(formattedDate)
      .collection('Meals')
      .where(FieldPath.documentId, isNotEqualTo: 'summary')
      .orderBy(FieldPath.documentId)
      .snapshots()
      .listen((event) async {
        List<FoodModel> mealsList = List.empty(growable: true);
        for (QueryDocumentSnapshot<Map<String, dynamic>> item in event.docs) {
          FoodModel foodModel = FoodModel.fromMap(item.data());
          mealsList.add(foodModel);
        }
        controller.add(mealsList);
      });

  ref.onDispose(() {
    controller.close();
    mealsSub.cancel();
  });

  return controller.stream;
});
