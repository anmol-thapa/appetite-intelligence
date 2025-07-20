import 'package:appetite_intelligence/services/auth_service.dart';
import 'package:appetite_intelligence/util/formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validators/validators.dart';

enum Gender { male, female }

enum MacroBalance { balanced, highProtein, highFat, lowCarb, keto }

enum WeightGoal { gain, maintain, lose }

enum ActivityLevel { sedetary, light, medium, heavy, athlete }

class OnboardingService {
  final int? age;
  final int? weight;
  final int? height;
  final Gender? gender;
  final MacroBalance? macroBalance;
  final WeightGoal? weightGoal;
  final ActivityLevel? activityLevel;
  final String? name;
  final String? email;
  final String? password;
  final Map<String, int>? macroGoals;
  final List<int>? cheatDays;

  OnboardingService({
    required this.age,
    required this.weight,
    required this.gender,
    required this.height,
    required this.macroBalance,
    required this.weightGoal,
    required this.activityLevel,
    required this.name,
    required this.email,
    required this.password,
    required this.macroGoals,
    required this.cheatDays,
  });

  OnboardingService copyWith({
    int? age,
    int? weight,
    int? height,
    Gender? gender,
    MacroBalance? macroBalance,
    WeightGoal? weightGoal,
    ActivityLevel? activityLevel,
    String? name,
    String? email,
    String? password,
    Map<String, int>? macroGoals,
    List<int>? cheatDays,
  }) {
    return OnboardingService(
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      macroBalance: macroBalance ?? this.macroBalance,
      weightGoal: weightGoal ?? this.weightGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      macroGoals: macroGoals ?? this.macroGoals,
      cheatDays: cheatDays ?? this.cheatDays,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingService> {
  OnboardingNotifier()
    : super(
        OnboardingService(
          age: null,
          weight: null,
          gender: null,
          height: null,
          macroBalance: null,
          weightGoal: null,
          activityLevel: null,
          name: null,
          email: null,
          password: null,
          macroGoals: null,
          cheatDays: null,
        ),
      );

  void setAge(int age) => state = state.copyWith(age: age);
  void setWeight(int weight) => state = state.copyWith(weight: weight);
  void setHeight(int height) => state = state.copyWith(height: height);
  void setGender(Gender gender) => state = state.copyWith(gender: gender);
  void setMacroBalance(MacroBalance macroBalance) =>
      state = state.copyWith(macroBalance: macroBalance);
  void setWeightGoal(WeightGoal goal) =>
      state = state.copyWith(weightGoal: goal);
  void setActivityLevel(ActivityLevel activityLevel) =>
      state = state.copyWith(activityLevel: activityLevel);
  void setName(String name) => state = state.copyWith(name: name);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String password) =>
      state = state.copyWith(password: password);
  void setCredentials({required String email, required String password}) =>
      state = state.copyWith(email: email, password: password);
  void setCheatMealDays({required List<int> cheatDays}) =>
      state = state.copyWith(cheatDays: cheatDays);

  void clear() {
    state = OnboardingService(
      age: null,
      weight: null,
      gender: null,
      height: null,
      macroBalance: null,
      weightGoal: null,
      activityLevel: null,
      name: null,
      email: null,
      password: null,
      macroGoals: null,
      cheatDays: null,
    );
  }

  String? validateFinalInput() {
    final name = state.name?.trim() ?? '';
    final email = state.email ?? '';
    final password = state.password ?? '';

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Please complete all fields.';
    } else if (name.length < 2) {
      return 'Name must be at least 2 characters long!';
    } else if (name.length > 15) {
      return 'Name must be less than 15 characters long!';
    } else if (!isEmail(email)) {
      return 'The email is not valid.';
    } else if (password.length < 6 || !isAscii(password)) {
      return 'The password must be at least 6 characters long and use only valid characters.';
    }
    return null;
  }

  Map<String, Map<String, double>> macroRatios = {
    'balanced': {'protein': 0.30, 'carbs': 0.40, 'fats': 0.30},
    'highProtein': {'protein': 0.40, 'carbs': 0.30, 'fats': 0.30},
    'highFat': {'protein': 0.25, 'carbs': 0.25, 'fats': 0.50},
    'lowCarb': {'protein': 0.40, 'carbs': 0.20, 'fats': 0.40},
    'keto': {'protein': 0.20, 'carbs': 0.05, 'fats': 0.75},
  };

  void calculateGoals() {
    final calories = calculateBmr();
    final ratios = macroRatios[state.macroBalance!.name]!;
    final macroGoals = {
      'caloric': calories,
      'fats': Formatter.roundToInt(ratios['fats']! * calories / 9),
      'carbs': Formatter.roundToInt(ratios['carbs']! * calories / 4),
      'protein': Formatter.roundToInt(ratios['protein']! * calories / 4),
    };
    state = state.copyWith(macroGoals: macroGoals);
  }

  int calculateBmr() {
    double calories;
    if (state.gender == Gender.male) {
      calories =
          (66 +
              (6.23 * state.weight!) +
              (12.7 * state.height!) -
              (6.8 * state.age!));
    } else {
      calories =
          (655 +
              (4.35 * state.weight!) +
              (4.7 * state.height!) -
              (4.7 * state.age!));
    }

    double mult;
    switch (state.activityLevel!) {
      case ActivityLevel.sedetary:
        mult = 1.2;
        break;
      case ActivityLevel.light:
        mult = 1.375;
        break;
      case ActivityLevel.medium:
        mult = 1.55;
        break;
      case ActivityLevel.heavy:
        mult = 1.725;
        break;
      case ActivityLevel.athlete:
        mult = 1.9;
        break;
    }

    return Formatter.roundToInt(calories * mult);
  }

  Future<String?> finalizeSignup() async {
    final validationMessage = validateFinalInput();
    if (validationMessage != null) throw Exception(validationMessage);
    calculateGoals();
    return await AuthService().signUp(state);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingService>(
      (ref) => OnboardingNotifier(),
    );
