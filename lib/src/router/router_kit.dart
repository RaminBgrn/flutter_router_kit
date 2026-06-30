import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/main_wrapper.dart';

/// این تابع کل بویلرپلیتِ ساخت GoRouter با shell رو می‌پوشونه.
/// هر اپ فقط کافیه:
///  ۱. لیست branchها (تب‌ها) رو با routeهای خودش بسازه
///  ۲. لیست destinations (آیتم‌های BottomNav) رو بده
///  ۳. (اختیاری) routeهای بیرون از شل (مثل login) رو بده
///
/// و دیگه نیازی نیست خودش StatefulShellRoute و MainWrapper رو دوباره بنویسه.
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
