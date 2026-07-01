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
}
