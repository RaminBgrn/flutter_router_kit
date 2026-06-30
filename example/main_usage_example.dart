// =========================================================
// این فایل نمونه‌ی استفاده از پکیج تو یه اپ دیگه‌ست.
// خودِ این فایل جزو پکیج نیست - این رو تو پروژه‌ی مصرف‌کننده می‌نویسی.
// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_router_kit/src/bindings/getx_binding_adapter.dart';
import 'package:flutter_router_kit/src/router/router_kit.dart';
import 'package:flutter_router_kit/src/widgets/main_wrapper.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// ---- صفحات خودِ این اپ ----
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) => ListTile(
          title: Text('محصول $i'),
          onTap: () =>
              context.pushNamed('productDetail', pathParameters: {'id': '$i'}),
        ),
      );
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => Center(child: Text('محصول $id'));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('پروفایل'));
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => HomeController());
  }
}

// ---- ساخت روتر با پکیج ----
final appRouter = buildShellRouter(
  initialLocation: '/home',
  destinations: const [
    AppNavDestination(icon: Icon(Icons.home), label: 'خانه'),
    AppNavDestination(icon: Icon(Icons.person), label: 'پروفایل'),
  ],
  onRootBackPressed: () {
    // مثلا دیالوگ تایید خروج از اپ
  },
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => buildWithBinding(
          binding: HomeBinding(),
          page: () => const HomePage(),
        ),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: 'productDetail',
            builder: (context, state) =>
                ProductDetailPage(id: state.pathParameters['id']!),
          ),
        ],
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (c, s) => const ProfilePage()),
    ]),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
