import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// چون GetxController به BuildContext دسترسی مستقیم نداره (برخلاف ویجت‌ها)،
/// این کلاس با استفاده از همون [rootNavigatorKey] که به GoRouter دادیم
/// context رو از پشت‌صحنه می‌گیره و کار ناوبری رو انجام میده.
///
/// تو کنترلرها به‌جای Get.offNamed/Get.toNamed از این استفاده کن:
/// AppNav.goNamed(RoutePath.homeName);
class AppNav {
  AppNav._();

  static GlobalKey<NavigatorState>? _navigatorKey;

  /// یک بار تو app_router.dart صداش بزن و همون rootNavigatorKey رو بده
  static void init(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  static BuildContext get _context {
    final ctx = _navigatorKey?.currentContext;
    assert(
        ctx != null, 'AppNav.init() صدا زده نشده یا Navigator هنوز mount نشده');
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

  /// معادل Get.dialog با تمام پراپرتی‌های showDialog فلاتر.
  /// از همون rootNavigatorKey استفاده می‌کنه، پس هم تو ویجت هم تو کنترلر کار می‌کنه.
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

  /// معادل Get.generalDialog با تمام پراپرتی‌های showGeneralDialog فلاتر.
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

  /// معادل Get.bottomSheet
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
