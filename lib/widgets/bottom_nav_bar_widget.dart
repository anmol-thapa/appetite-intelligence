import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/services/route_helper_service.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: KColors.primaryColor, width: 2)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RouterIcon(
            index: 0,
            destination: '/',
            unselectedIcon: Icons.home_outlined,
            selectedIcon: Icons.home,
          ),
          RouterIcon(
            index: 1,
            destination: '/analysis',
            unselectedIcon: Icons.pie_chart_outline,
            selectedIcon: Icons.pie_chart,
          ),
        ],
      ),
    );
  }
}

class RouterIcon extends StatelessWidget {
  const RouterIcon({
    super.key,
    required this.index,
    required this.destination,
    required this.unselectedIcon,
    required this.selectedIcon,
  });
  final int index;
  final String destination;
  final IconData unselectedIcon;
  final IconData selectedIcon;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object>(
      valueListenable: selectedPageNotifer,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () => route(context, destination, index),
          icon: Icon(value == index ? selectedIcon : unselectedIcon),
          color: value == index ? KColors.primaryColor : Colors.grey,
          iconSize: 32,
        );
      },
    );
  }
}
