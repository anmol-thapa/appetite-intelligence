import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddIconWidget extends StatelessWidget {
  AddIconWidget({super.key});
  final GlobalKey addButtonKey = GlobalKey();

  void showAddFoodPopup() {
    final box = addButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: addButtonKey.currentContext!,
      barrierLabel: "Popup",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: AddFoodPopup(position: position),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: addButtonKey,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(color: KColors.primaryColor, width: 2),
        ),
        color: KColors.primaryColor,
      ),
      child: IconButton(
        onPressed: showAddFoodPopup,
        icon: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddFoodPopup extends StatelessWidget {
  const AddFoodPopup({super.key, required this.position});
  final Offset position;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: position.dy - 125,
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                MealIcon(
                  mealIcon: KBottomNavBar.breakfastIcon,
                  mealTime: MealTime.breakfast,
                ),
                MealIcon(
                  mealIcon: KBottomNavBar.lunchIcon,
                  mealTime: MealTime.lunch,
                ),
                MealIcon(
                  mealIcon: KBottomNavBar.dinnerIcon,
                  mealTime: MealTime.dinner,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: position.dy,
          left: position.dx,
          child: ElevatedAddButton(),
        ),
      ],
    );
  }
}

class MealIcon extends StatelessWidget {
  const MealIcon({super.key, required this.mealIcon, required this.mealTime});
  final AssetImage mealIcon;
  final MealTime mealTime;

  @override
  Widget build(BuildContext context) {
    String mealName =
        mealTime.name[0].toUpperCase() + mealTime.name.substring(1);
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          IconButton.filled(
            onPressed: () {
              context.pop();
              context.push("/meal-add/${mealTime.name}");
            },
            icon: ImageIcon(mealIcon, size: 38),
            style: IconButton.styleFrom(backgroundColor: KColors.primaryColor),
          ),
          Text(mealName, style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}

class ElevatedAddButton extends StatelessWidget {
  const ElevatedAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(color: KColors.primaryColor, width: 2),
        ),
        color: KColors.primaryColor,
      ),
      child: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.clear, color: Colors.white),
      ),
    );
  }
}
