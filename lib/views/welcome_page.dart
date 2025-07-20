import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/widgets/reusables/primary_button_widget.dart';
import 'package:appetite_intelligence/widgets/reusables/secondary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final AnimationController titleAnimationController;
  late final AnimationController descAnimationController;
  late final Animation<double> titleFadeIn;
  late final Animation<double> descFadeIn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    titleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    titleFadeIn = CurvedAnimation(
      parent: titleAnimationController,
      curve: Curves.easeInOut,
    );
    descAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    descFadeIn = CurvedAnimation(
      parent: descAnimationController,
      curve: Curves.easeInOut,
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        startFadeIn();
      }
    });
  }

  void startFadeIn() async {
    titleAnimationController.forward();
    await Future.delayed(Duration(milliseconds: 750));
    descAnimationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    titleAnimationController.dispose();
    descAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          FadeTransition(
            opacity: titleFadeIn,
            child: Text(
              'Appetite Intelligence',
              style: KWelcomePageStyle.titleText,
            ),
          ),
          SizedBox(height: 25),
          FadeTransition(
            opacity: descFadeIn,
            child: Text(
              'Your eating habits,'
              '\n'
              'evolved by AI.',
              style: KWelcomePageStyle.descText,
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: Lottie.asset(
              height: 300,
              'assets/lotties/salad_bowl.json',
              frameRate: FrameRate(120),
              controller: animationController,
              repeat: false,
              onLoaded:
                  (composition) =>
                      animationController
                        ..duration = composition.duration
                        ..forward(),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  onClick: () => context.push('/onboarding/1'),
                  text: 'Get Started',
                ),
                SecondaryButton(
                  onClick: () => context.push('/login'),
                  text: 'Login',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
