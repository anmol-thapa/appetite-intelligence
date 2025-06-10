import 'package:appetite_intelligence/models/summary_model.dart';
import 'package:appetite_intelligence/services/date_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final db = FirebaseFirestore.instance;

  static Future<SummaryModel> getSummaryFor(DateTime date) async {
    final summaryDocData = await getDocDataFor(date);

    if (summaryDocData == null) {
      return await SummaryModel.defaultModel();
    }
    return SummaryModel.fromMap(summaryDocData);
  }

  static Future<Map<String, dynamic>?> getDocDataFor(DateTime date) async {
    String formattedDate = Formatter.dateFormat(date: date);

    final summaryRef = db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Logs')
        .doc(formattedDate)
        .collection('Meals')
        .doc('summary');

    final summaryDoc = await summaryRef.get();

    if (!summaryDoc.exists) {
      return null;
    }

    return summaryDoc.data();
  }

  /// 1. Get the current NTP date
  /// 2. Turn it into the formatted date for retrieval
  /// 3. Use the current NTP date and keep going back [duration] days in increments of 1 day
  /// 4. Keep track of each doc content, and return the entire list of doc files
  static Future<List<Map<String, dynamic>>> getMealDocsWithin(
    Duration duration,
  ) async {
    final currentDate = await DateService.getNetworkTime();
    if (currentDate == null) {
      return [];
    }

    final oneDay = Duration(days: 1);
    final goalDate = currentDate.subtract(duration);

    List<Map<String, dynamic>> docs = List.empty(growable: true);
    DateTime adjustedTime = currentDate;

    while (adjustedTime.isAtSameMomentAs(goalDate) ||
        adjustedTime.isAfter(goalDate)) {
      final data = await getDocDataFor(adjustedTime);

      if (data != null) {
        docs.add(data);
      }

      adjustedTime = adjustedTime.subtract(oneDay);
    }

    return docs;
  }
}
