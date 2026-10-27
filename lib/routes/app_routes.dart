import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/component_gallery_screen/component_gallery_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String componentGalleryScreen = '/component-gallery-screen';
  static const String settingsScreen = '/settings-screen';
}

CustomTransitionPage<void> _fadeSlide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AppScaffoldHome(),
        transitionDuration: const Duration(milliseconds: 280),
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            ),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeScreen,
              pageBuilder: (context, state) =>
                  _fadeSlide(state, const HomeScreen()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.settingsScreen,
      pageBuilder: (context, state) =>
          _fadeSlide(state, const SettingsScreen()),
    ),
    GoRoute(
      path: AppRoutes.componentGalleryScreen,
      pageBuilder: (context, state) =>
          _fadeSlide(state, const ComponentGalleryScreen()),
    ),
  ],
);

/// '/' lands directly on Home via a one-frame redirect inside initState.
class AppScaffoldHome extends StatefulWidget {
  const AppScaffoldHome({super.key});

  @override
  State<AppScaffoldHome> createState() => _AppScaffoldHomeState();
}

class _AppScaffoldHomeState extends State<AppScaffoldHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(AppRoutes.homeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
