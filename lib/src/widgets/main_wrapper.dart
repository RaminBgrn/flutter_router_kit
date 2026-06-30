import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// نوع تابعی که برای هر آیتم BottomNav نیاز داریم.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// قاب اصلی و ثابت اپ.
/// این ویجت فقط یک بار توسط StatefulShellRoute.indexedStack ساخته میشه
/// و دیگه rebuild نمیشه وقتی بین تب‌ها سوییچ می‌کنی.
///
/// چون generic نوشته شده، هر اپی که این پکیج رو import کنه فقط کافیه
/// appBarTitle و destinations خودش رو پاس بده، نیازی به بازنویسی نیست.
class MainWrapper extends StatelessWidget {
  const MainWrapper({
    super.key,
    required this.navigationShell,
    required this.destinations,
    this.appBarBuilder,
    this.onRootBackPressed,
  });

  /// شِل ناوبری که خود go_router در اختیارمون میذاره
  final StatefulNavigationShell navigationShell;

  /// لیست آیتم‌های BottomNav - این رو هر اپ خودش تعریف می‌کنه
  final List<AppNavDestination> destinations;

  /// اگه بخوای AppBar سفارشی بسازی (مثلا هر تب AppBar متفاوت داشته باشه)
  /// این رو پاس بده. اگه ندی، یه AppBar پیش‌فرض ساده ساخته میشه.
  final PreferredSizeWidget Function(BuildContext context, int currentIndex)?
      appBarBuilder;

  /// وقتی کاربر روی تب اول (ریشه) هست و دکمه بک فیزیکی رو میزنه
  /// و دیگه جایی برای pop نیست، این callback صدا زده میشه.
  /// خود اپ تصمیم میگیره: دیالوگ خروج نشون بده، یا اپ رو ببنده و ...
  final VoidCallback? onRootBackPressed;

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.canPop() از خود go_router میاد و بررسی میکنه که آیا
    // Navigator فعلی (یعنی همون branch/تبی که الان توشیم) استک pop‌پذیر داره یا نه.
    // این جایگزین درستِ navigationShell.canPop هست که اصلاً وجود نداره.
    final canPopCurrentBranch = context.canPop();

    return PopScope(
      canPop: !canPopCurrentBranch,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // حالت ۱: داخل یه nested route هستیم -> go_router خودش برمیگردونه
        if (canPopCurrentBranch) {
          context.pop();
          return;
        }

        // حالت ۲: روی ریشه‌ی یکی از تب‌های غیر از تب اول هستیم -> برو تب اول
        if (navigationShell.currentIndex != 0) {
          _onTabTapped(0);
          return;
        }

        // حالت ۳: روی ریشه‌ی تب اول هستیم و دیگه جایی نیست -> به خود اپ بسپار
        onRootBackPressed?.call();
      },
      child: Scaffold(
        appBar: appBarBuilder?.call(context, navigationShell.currentIndex) ??
            AppBar(
                title: Text(destinations[navigationShell.currentIndex].label)),
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: destinations
              .map((d) => NavigationDestination(
                    icon: d.icon,
                    selectedIcon:
                        d.selectedIcon != null ? d.selectedIcon : null,
                    label: d.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
