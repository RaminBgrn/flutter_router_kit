import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Since a GetxController has no direct access to a BuildContext (unlike
/// widgets), this class uses the same [rootNavigatorKey] that was given to
/// GoRouter to grab the context behind the scenes and do the navigation.
///
/// In controllers, use this instead of Get.offNamed/Get.toNamed:
/// AppNav.goNamed(RoutePath.homeName);
class AppNav {
  AppNav._();

  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Call it once in app_router.dart and give it the same rootNavigatorKey
  static void init(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  static BuildContext get _context {
    final ctx = _navigatorKey?.currentContext;
    assert(ctx != null,
        'AppNav.init() has not been called, or the Navigator is not mounted yet');
    return ctx!;
  }

  static void pushNamed(String name,
          {Map<String, String>? pathParameters, Object? extra}) =>
      _context.pushNamed(name,
          pathParameters: pathParameters ?? const {}, extra: extra);

  static void goNamed(String name,
          {Map<String, String>? pathParameters, Object? extra}) =>
      _context.goNamed(name,
          pathParameters: pathParameters ?? const {}, extra: extra);

  static void go(String path, {Object? extra}) =>
      _context.go(path, extra: extra);

  static void pop([Object? result]) => _context.pop(result);

  static bool canPop() => _context.canPop();

  /// The equivalent of Get.dialog, with all of Flutter's showDialog properties.
  /// It uses the same rootNavigatorKey, so it works in both widgets and controllers.
  static Future<T?> dialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return showDialog<T>(
      context: _context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }

  /// The equivalent of Get.generalDialog, with all of Flutter's showGeneralDialog properties.
  static Future<T?> generalDialog<T>({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = false,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    return showGeneralDialog<T>(
      context: _context,
      pageBuilder: pageBuilder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    );
  }

  /// The equivalent of Get.bottomSheet
  static Future<T?> bottomSheet<T>({
    required Widget widget,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: _context,
      builder: (_) => widget,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }
}
