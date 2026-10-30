import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/main_wrapper.dart';

/// This function wraps all the boilerplate of building a GoRouter with a shell.
/// Each app only needs to:
///  1. Build the list of branches (tabs) with its own routes
///  2. Provide the list of destinations (BottomNav items)
///  3. (Optional) Provide routes that live outside the shell (such as login)
///
/// and it no longer needs to write StatefulShellRoute and MainWrapper itself.
GoRouter buildShellRouter({
  required String initialLocation,
  required List<StatefulShellBranch> branches,
  required List<AppNavDestination> destinations,
  List<RouteBase> outsideRoutes = const [],
  GlobalKey<NavigatorState>? rootNavigatorKey,
  PreferredSizeWidget Function(BuildContext context, int currentIndex)? appBarBuilder,
  VoidCallback? onRootBackPressed,
}) {
  final navKey = rootNavigatorKey ?? GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: navKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainWrapper(
          navigationShell: navigationShell,
          destinations: destinations,
          appBarBuilder: appBarBuilder,
          onRootBackPressed: onRootBackPressed,
        ),
        branches: branches,
      ),
      ...outsideRoutes,
    ],
  );
}
