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
    test('selectedIcon به‌صورت پیش‌فرض null است', () {
      const destination = AppNavDestination(
        icon: Icon(Icons.home),
        label: 'خانه',
      );

      expect(destination.label, 'خانه');
      expect(destination.selectedIcon, isNull);
    });

    test('selectedIcon وقتی داده شود نگه داشته می‌شود', () {
      const selected = Icon(Icons.home_filled);
      const destination = AppNavDestination(
        icon: Icon(Icons.home),
        selectedIcon: selected,
        label: 'خانه',
      );

      expect(destination.selectedIcon, same(selected));
    });
  });

  group('buildWithBinding', () {
    test('قبل از ساخت صفحه، dependencies بایندینگ را صدا می‌زند', () {
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

    test('دقیقاً همان ویجتی را برمی‌گرداند که page ساخته', () {
      const page = SizedBox(key: ValueKey('page'));

      final result = buildWithBinding(
        binding: _FakeBinding(),
        page: () => page,
      );

      expect(result, same(page));
    });
  });

  group('buildShellRouter', () {
    test('روتر را با initialLocation و routeهای بیرون از شل می‌سازد', () {
      final router = buildShellRouter(
        initialLocation: '/home',
        destinations: const [
          AppNavDestination(icon: Icon(Icons.home), label: 'خانه'),
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
