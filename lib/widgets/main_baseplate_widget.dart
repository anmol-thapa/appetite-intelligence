import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/widgets/add_icon_widget.dart';
import 'package:appetite_intelligence/widgets/bottom_nav_bar_widget.dart';
import 'package:appetite_intelligence/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';

class MainBaseplate extends StatelessWidget {
  final Widget child;
  const MainBaseplate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: KPageSettings.pagePadding,
          child: Column(
            children: [
              SizedBox(height: 50),
              TopBarWidget(),
              SizedBox(height: 25),
              child,
            ],
          ),
        ),
      ),
      floatingActionButton: AddIconWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
