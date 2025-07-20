enum MealTime { breakfast, lunch, dinner }

enum HealthRating { healthy, neutral, junk }

class FoodModel {
  final String name;
  final Map<String, int> nitrution;
  final MealTime mealTime;
  final HealthRating healthRating;
  final String loggedAt;
  final Map<String, dynamic> serving;

  FoodModel({
    required this.name,
    required this.nitrution,
    required this.mealTime,
    required this.healthRating,
    required this.loggedAt,
    required this.serving,
  });

  // Convert from JSON string to Object
  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      name: data['name'],
      nitrution: Map.from(data['nitrution']),
      mealTime: MealTime.values.byName(data['mealTime']),
      healthRating: HealthRating.values.byName(data['healthRating']),
      loggedAt: data['loggedAt'],
      serving: Map.from(data['serving']),
    );
  }

  // Convert from Object to JSON String
  Map<String, dynamic> toMap() => {
    'name': name,
    'nitrution': nitrution,
    'mealTime': mealTime.name,
    'healthRating': healthRating.name,
    'loggedAt': loggedAt,
    'serving': serving,
  };

  static FoodModel create({
    required String name,
    required Map<String, int> nitrution,
    required MealTime mealTime,
    required HealthRating healthRating,
    required Map<String, dynamic> serving,
  }) {
    return FoodModel(
      name: name,
      nitrution: nitrution,
      mealTime: mealTime,
      healthRating: healthRating,
      loggedAt: DateTime.now().toUtc().toIso8601String(),
      serving: serving,
    );
  }
}
