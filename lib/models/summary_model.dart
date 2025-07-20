import 'package:appetite_intelligence/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SummaryModel {
  final int caloriesConsumed;
  final int caloriesAllowed;
  final Map<String, int> macroCount;
  final Map<String, int> macroAllowed;
  final Map<String, int> mealRatingCount;
  final Map<String, Map<String, int>> mealRatingMacroCount;
  final Map<String, int> mealTimeCount;
  final bool loggedFood;

  SummaryModel({
    required this.caloriesConsumed,
    required this.caloriesAllowed,
    required this.macroCount,
    required this.macroAllowed,
    required this.mealRatingCount,
    required this.mealRatingMacroCount,
    required this.mealTimeCount,
    required this.loggedFood,
  });

  static Future<Map<String, dynamic>> defaultMap() async {
    final docSnapshot =
        await DatabaseService.db
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    final goals = docSnapshot.data()?['goals'] ?? {};

    return {
      'caloriesConsumed': 0,
      'caloriesAllowed': goals['caloric'] ?? 0,
      'macroCount': {'fats': 0, 'carbs': 0, 'protein': 0},
      'macroAllowed': {
        'fats': goals['fats'] ?? 0,
        'carbs': goals['carbs'] ?? 0,
        'protein': goals['protein'] ?? 0,
      },
      'mealRatingCount': {'healthy': 0, 'neutral': 0, 'junk': 0},
      'mealRatingMacroCount': {
        'healthy': {'fats': 0, 'carbs': 0, 'protein': 0},
        'neutral': {'fats': 0, 'carbs': 0, 'protein': 0},
        'junk': {'fats': 0, 'carbs': 0, 'protein': 0},
      },
      'mealTimeCount': {'breakfast': 0, 'lunch': 0, 'dinner': 0},
      'loggedFood': false,
    };
  }

  static SummaryModel fromMap(Map<String, dynamic> data) {
    Map<String, int> fallbackMap(Map? raw, List<String> keys) {
      return {for (var key in keys) key: raw?[key] ?? 0};
    }

    Map<String, Map<String, int>> fallbackNestedMap(
      Map? raw,
      List<String> outerKeys,
      List<String> innerKeys,
    ) {
      return {
        for (var outer in outerKeys)
          outer: fallbackMap(
            raw?[outer] is Map ? Map<String, dynamic>.from(raw![outer]) : null,
            innerKeys,
          ),
      };
    }

    return SummaryModel(
      caloriesConsumed: data['caloriesConsumed'] ?? 0,
      caloriesAllowed: data['caloriesAllowed'] ?? 0,
      macroCount: fallbackMap(data['macroCount'], ['fats', 'carbs', 'protein']),
      macroAllowed: fallbackMap(data['macroAllowed'], [
        'fats',
        'carbs',
        'protein',
      ]),
      mealRatingCount: fallbackMap(data['mealRatingCount'], [
        'healthy',
        'neutral',
        'junk',
      ]),
      mealRatingMacroCount: fallbackNestedMap(
        data['mealRatingMacroCount'],
        ['healthy', 'neutral', 'junk'],
        ['fats', 'carbs', 'protein'],
      ),
      mealTimeCount: fallbackMap(data['mealTimeCount'], [
        'breakfast',
        'lunch',
        'dinner',
      ]),
      loggedFood: data['loggedFood'] ?? false,
    );
  }

  static Future<SummaryModel> defaultModel() async {
    final data = await defaultMap();
    return fromMap(data);
  }
}
