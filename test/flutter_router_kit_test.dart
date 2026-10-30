import 'package:flutter/material.dart';
import 'package:flutter_router_kit/flutter_router_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeBinding extends Bindings {
  bool dependenciesCalled = false;

  @override
  void dependencies() {
    dependenciesCalled = true;
  }
}

void main() {
  group('AppNavDestination', () {
    test('selectedIcon is null by default', () {
      const destination = AppNavDestination(
        icon: Icon(Icons.home),
        label: 'Home',
      );

      expect(destination.label, 'Home');
      expect(destination.selectedIcon, isNull);
    });

    test('selectedIcon is kept when provided', () {
      const selected = Icon(Icons.home_filled);
      const destination = AppNavDestination(
        icon: Icon(Icons.home),
        selectedIcon: selected,
        label: 'Home',
      );

      expect(destination.selectedIcon, same(selected));
    });
  });

  group('buildWithBinding', () {
    test('calls the binding dependencies before building the page', () {
      final binding = _FakeBinding();
      var pageBuilt = false;

      final result = buildWithBinding(
        binding: binding,
        page: () {
          pageBuilt = true;
          return const SizedBox();
        },
      );

      expect(binding.dependenciesCalled, isTrue);
      expect(pageBuilt, isTrue);
      expect(result, isA<SizedBox>());
    });

    test('returns exactly the widget that page built', () {
      const page = SizedBox(key: ValueKey('page'));

      final result = buildWithBinding(
        binding: _FakeBinding(),
        page: () => page,
      );

      expect(result, same(page));
    });
  });

  group('buildShellRouter', () {
    test('builds the router with an initialLocation and routes outside the shell', () {
      final router = buildShellRouter(
        initialLocation: '/home',
        destinations: const [
          AppNavDestination(icon: Icon(Icons.home), label: 'Home'),
        ],
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const SizedBox(),
            ),
          ]),
        ],
        outsideRoutes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const SizedBox(),
          ),
        ],
      );

      expect(router.configuration.routes.length, 2);
      router.dispose();
    });
  });
}
