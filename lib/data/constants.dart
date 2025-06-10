import 'package:flutter/material.dart';

enum Macros { fats, carbs, protein }

class KColors {
  static const Color primaryColor = Color.fromARGB(255, 112, 208, 155);
  static const Color primaryGray = Color.fromARGB(255, 232, 232, 232);
  static const Color primaryCaution = KColors.fatsColor;
  static const Color primaryNegative = Color.fromARGB(255, 254, 110, 74);

  static const Color proteinColor = KColors.primaryColor;
  static const Color carbsColor = Color.fromARGB(255, 254, 137, 74);
  static const Color fatsColor = Color.fromARGB(255, 254, 191, 74);
  static const Color neturalColor = Color(0xFF8EAEDC);
}

class KPageSettings {
  static const EdgeInsets pagePadding = EdgeInsets.all(24);
}

class KAnimation {
  static const Duration progressFillDuration = Duration(milliseconds: 750);
  static const Curve progressFillCurve = Curves.decelerate;
}

class KWelcomePageStyle {
  static const TextStyle titleText = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle descText = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
  );
}

class KHomePageStyle {
  static const TextStyle titleWelcomeText = TextStyle(fontSize: 18, height: 1);

  static const TextStyle titleNameText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );

  static const Icon searchIcon = Icon(Icons.search, size: 30);
  static const Icon settingsIcon = Icon(Icons.settings, size: 30);
}

class KFoodItemCardStyle {
  static const TextStyle foodName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const foodInfo = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  static const verticalMacroName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const horizontallMacroName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const macroAmount = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}

class KMainProgressBarStyle {
  static const TextStyle mainCalories = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle outOfCalories = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
}

class KBottomNavBar {
  static const AssetImage breakfastIcon = AssetImage(
    'assets/icons/sunrise.png',
  );
  static const AssetImage lunchIcon = AssetImage('assets/icons/sunny.png');
  static const AssetImage dinnerIcon = AssetImage('assets/icons/moon.png');
}

class KMethodUrl {
  static const String addUserURL =
      'https://us-east4-appetite-intelligence.cloudfunctions.net/addUser';
}
