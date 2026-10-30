import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The data each BottomNav item needs.
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

/// The main, fixed frame of the app.
/// This widget is built only once by StatefulShellRoute.indexedStack
/// and is not rebuilt when you switch between tabs.
///
/// Since it is written generically, any app that imports this package only
/// needs to pass its own destinations (and optionally an appBarBuilder).
/// There is no need to rewrite it.
class MainWrapper extends StatelessWidget {
  const MainWrapper({
    super.key,
    required this.navigationShell,
    required this.destinations,
    this.appBarBuilder,
    this.onRootBackPressed,
  });

  /// The navigation shell that go_router itself provides
  final StatefulNavigationShell navigationShell;

  /// The list of BottomNav items. Each app defines its own
  final List<AppNavDestination> destinations;

  /// If you want to build a custom AppBar (for example a different AppBar
  /// per tab), pass this. If you do not, a simple default AppBar is built.
  final PreferredSizeWidget Function(BuildContext context, int currentIndex)?
      appBarBuilder;

  /// Called when the user is on the first tab (the root) and presses the
  /// physical back button and there is nowhere left to pop.
  /// The app itself decides: show an exit dialog, close the app, and so on.
  final VoidCallback? onRootBackPressed;

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.canPop() comes from go_router itself and checks whether the
    // current Navigator (that is, the branch/tab we are in) has a stack
    // that can be popped.
    // This is the correct replacement for navigationShell.canPop, which
    // does not exist at all.
    final canPopCurrentBranch = context.canPop();

    return PopScope(
      canPop: !canPopCurrentBranch,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Case 1: we are inside a nested route -> go_router pops it itself
        if (canPopCurrentBranch) {
          context.pop();
          return;
        }

        // Case 2: we are at the root of a tab other than the first -> go to the first tab
        if (navigationShell.currentIndex != 0) {
          _onTabTapped(0);
          return;
        }

        // Case 3: we are at the root of the first tab and there is nowhere left -> hand it to the app itself
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
