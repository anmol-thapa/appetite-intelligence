import 'package:appetite_intelligence/models/food_model.dart';
import 'package:appetite_intelligence/util/formatter.dart';

class ScannedFoodModel {
  final String name;
  final int calories;
  final int fats;
  final int carbs;
  final int protein;
  final double servingSize;
  final int baseServingSize;
  final String servingUnit;
  final HealthRating? predictedHealthRating;

  ScannedFoodModel({
    required this.name,
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.protein,
    required this.servingSize,
    required this.baseServingSize,
    required this.servingUnit,
    required this.predictedHealthRating,
  });

  /// Returns [ScannedFoodModel] using the JSON result from OpenFoodFacts API
  static ScannedFoodModel? parseFromData(Map<String, dynamic> decodedData) {
    if (decodedData['status'] != 1) return null;
    Map<String, dynamic> product = decodedData["product"];
    Map<String, dynamic> nutriments = product["nutriments"];

    String name = product["product_name"];
    int calories = Formatter.roundToInt(
      nutriments["energy-kcal_serving"] ?? nutriments["energy-kcal"],
    );
    int fats = Formatter.roundToInt(
      nutriments["fat_serving"] ?? nutriments["fat"],
    );
    int carbs = Formatter.roundToInt(
      nutriments["carbohydrates_serving"] ?? nutriments["carbohydrates"],
    );
    int protein = Formatter.roundToInt(
      nutriments["proteins_serving"] ?? nutriments["proteins"],
    );

    double servingSize;
    int baseServingSize;

    if (product["serving_quantity"] != null) {
      double size = double.parse(product["serving_quantity"]);

      servingSize = size;
      baseServingSize = Formatter.roundToInt(size);
    } else {
      servingSize = 1;
      baseServingSize = 1;
    }

    String servingUnit =
        product["serving_quantity_unit"] ??
        product["serving_size"] ??
        'serving';
    if (servingUnit.length > 7) {
      // Some foods units are contained within parenthesis
      final regex = RegExp(r'\((?:[^()\s]*\s)*([^()\s]+)\)');
      final match = regex.firstMatch(servingUnit);
      if (match != null) {
        servingUnit = match.group(1)!;
      }
    }

    String? nutriScore = product["nutriscore_grade"];
    HealthRating? predictedHealthRating;
    switch (nutriScore) {
      case 'a':
      case 'b':
        predictedHealthRating = HealthRating.healthy;
        break;
      case 'c':
        predictedHealthRating = HealthRating.netural;
        break;
      case 'd':
      case 'e':
        predictedHealthRating = HealthRating.junk;
        break;
    }

    return ScannedFoodModel(
      name: name,
      calories: calories,
      fats: fats,
      carbs: carbs,
      protein: protein,
      servingSize: servingSize,
      baseServingSize: baseServingSize,
      servingUnit: servingUnit,
      predictedHealthRating: predictedHealthRating,
    );
  }
}
