# flutter_router_kit

A ready-made kit for setting up go_router with:

- A fixed shell built on `StatefulShellRoute.indexedStack`, so the AppBar and BottomNav are not rebuilt when switching tabs
- Nested routes inside each tab
- Physical back button handling: pop inside the current tab first, then return to the first tab, and at the root of the first tab hand control back to the app
- Context-free navigation from inside controllers with `AppNav`
- GetX Bindings support with `buildWithBinding`

## Installation

```yaml
  flutter_router_kit:
    git:
      url: https://github.com/RaminBgrn/flutter_router_kit.git
      ref: main
```

Dependencies: `go_router: ^14.0.0` and `get: ^4.6.6`

## Quick start

Your app only needs to provide two things: the branches for each tab and the BottomNav items.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_router_kit/flutter_router_kit.dart';

final appRouter = buildShellRouter(
  initialLocation: '/home',
  destinations: const [
    AppNavDestination(icon: Icon(Icons.home), label: 'Home'),
    AppNavDestination(icon: Icon(Icons.person), label: 'Profile'),
  ],
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/home', name: 'home', builder: (c, s) => const HomePage()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/profile', name: 'profile', builder: (c, s) => const ProfilePage()),
    ]),
  ],
);

// In your app:
MaterialApp.router(routerConfig: appRouter);
```

A fuller example, with a nested route and a Binding, is in `example/main_usage_example.dart`.

## `buildShellRouter` parameters

- `initialLocation` (required): the starting location of the app
- `branches` (required): the list of `StatefulShellBranch`es, one per tab
- `destinations` (required): the BottomNav items of type `AppNavDestination`, with an `icon`, a `label`, and an optional `selectedIcon`
- `outsideRoutes`: routes that live outside the shell, such as a login page
- `rootNavigatorKey`: the root Navigator key. One is created for you if you do not pass it. To use `AppNav` you must pass the same key to it (see below)
- `appBarBuilder`: builds a custom AppBar based on the current tab index. If you do not pass it, a default AppBar with the current tab label as its title is built
- `onRootBackPressed`: called when the user presses the physical back button at the root of the first tab and there is nowhere left to pop, so the app itself can decide what to do (for example show an exit confirmation dialog)

## Context-free navigation with `AppNav`

GetX controllers do not have direct access to a BuildContext. `AppNav` grabs the context through the same `rootNavigatorKey` and provides:

- `AppNav.goNamed(name)` and `AppNav.pushNamed(name)`, with `pathParameters` and `extra`
- `AppNav.go(path)`, `AppNav.pop()` and `AppNav.canPop()`
- `AppNav.dialog(...)`, `AppNav.generalDialog(...)` and `AppNav.bottomSheet(...)`, mirroring the Flutter functions of the same behaviour

Before using it, initialize it once while building your router:

```dart
final rootKey = GlobalKey<NavigatorState>();

AppNav.init(rootKey);

final appRouter = buildShellRouter(
  rootNavigatorKey: rootKey,
  // ...
);
```

## Using a GetX Binding in routes

go_router has no concept of a Binding, so call this inside the builder:

```dart
GoRoute(
  path: '/home',
  builder: (context, state) => buildWithBinding(
    binding: HomeBinding(),
    page: () => const HomePage(),
  ),
)
```

## License

MIT. See the `LICENSE` file.
