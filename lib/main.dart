import 'package:appetite_intelligence/services/date_service.dart';
import 'package:appetite_intelligence/services/route_helper_service.dart';
import 'package:appetite_intelligence/services/firebase_user_service.dart';
import 'package:appetite_intelligence/views/home_page.dart';
import 'package:appetite_intelligence/widgets/main_baseplate_widget.dart';
import 'package:appetite_intelligence/views/onboarding_page.dart';
import 'package:appetite_intelligence/views/analysis_page.dart';
import 'package:appetite_intelligence/views/settings_page.dart';
import 'package:appetite_intelligence/views/add_food_page.dart';
import 'package:appetite_intelligence/views/welcome_page.dart';
import 'package:appetite_intelligence/widgets/base_scaffold_page.dart';
import 'package:appetite_intelligence/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync time
    ref.read(dateSelectionProvider.notifier).sync();

    final router = GoRouter(
      initialLocation: '/welcome',
      redirect: (context, state) {
        final userAsync = ref.watch(firebaseUser);

        // Don't redirect in login/welcome/onboarding pages
        final isLoggingOrSigningUp = RegExp(
          r'^/(login|welcome|onboarding)(/.*)?$',
        ).hasMatch(state.matchedLocation);

        return userAsync.when(
          data: (user) {
            final isLoggedIn = user != null;

            if (!isLoggedIn && !isLoggingOrSigningUp) return '/welcome';
            if (isLoggedIn && isLoggingOrSigningUp) return '/';
            return null;
          },
          loading: () => null,
          error: (_, __) => '/welcome',
        );
      },
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainBaseplate(child: child),
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => noTransitionPage(HomePage()),
            ),
            GoRoute(
              path: '/analysis',
              pageBuilder: (context, state) => noTransitionPage(AnalysisPage()),
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder:
              (context, state) =>
                  BaseScaffoldPage(showAppBar: true, child: SettingsPage()),
        ),
        GoRoute(
          path: '/meal-add/:mealTime',
          builder: (context, state) {
            final mealTimeName = state.pathParameters['mealTime'];
            return BaseScaffoldPage(
              scroll: true,
              appBar: AppBar(title: Text('Logging $mealTimeName')),
              child: AddFoodPage(mealTimeName: mealTimeName!),
            );
          },
        ),
        GoRoute(
          path: '/welcome',
          builder:
              (context, state) =>
                  BaseScaffoldPage(scroll: true, child: WelcomePage()),
        ),
        GoRoute(
          path: '/onboarding/:page',
          builder: (context, state) {
            final options = [
              OnboardingPage1(),
              OnBoardingPage2(),
              OnBoardingPage3(),
              OnBoardingPage4(),
              OnBoardingPage5(),
              OnBoardingPage6(),
            ];

            final index =
                (int.tryParse(state.pathParameters['page']!) ?? 0) - 1;

            return BaseScaffoldPage(
              showAppBar: true,
              child: options[index.clamp(0, options.length - 1)],
            );
          },
        ),

        GoRoute(
          path: '/login',
          builder:
              (context, state) => BaseScaffoldPage(
                showAppBar: true,
                scroll: true,
                child: LoginPage(),
              ),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      routerConfig: router,
    );
  }
}
