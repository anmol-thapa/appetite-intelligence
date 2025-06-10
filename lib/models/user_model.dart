class UserModel {
  final String email;
  final String name;
  final int weight;
  final int age;
  final int height;
  final Map<String, int> goals;
  final List<int> cheatMeals;
  final String createdAt;

  UserModel({
    required this.email,
    required this.name,
    required this.goals,
    required this.cheatMeals,
    required this.createdAt,
    required this.weight,
    required this.age,
    required this.height,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      name: data['name'],
      weight: data['weight'],
      age: data['age'],
      height: data['height'],
      goals: Map.from(data['goals']),
      cheatMeals: List.from(data['cheatMeals']),
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'goals': goals,
    'weight': weight,
    'height': height,
    'age': age,
    'cheatMeals': cheatMeals,
    'createdAt': createdAt,
  };

  static UserModel create({
    required String email,
    required String name,
    required int weight,
    required int age,
    required int height,
    required Map<String, int> macroGoals,
    required List<int> cheatMeals,
  }) {
    return UserModel(
      email: email,
      name: name,
      goals: Map.from(macroGoals),
      weight: weight,
      height: height,
      age: age,
      cheatMeals: List.from(cheatMeals),
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
  }
}
