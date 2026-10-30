// =========================================================
// This file is an example of using the package in another app.
// This file itself is not part of the package. You write this
// in the consuming project.
// =========================================================

import 'package:flutter/material.dart';
// Use only the public API of the package, not the internal src/ files
// (go_router is also re-exported from this entrypoint)
import 'package:flutter_router_kit/flutter_router_kit.dart';
import 'package:get/get.dart';

// ---- This app's own pages ----
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) => ListTile(
          title: Text('Product $i'),
          onTap: () =>
              context.pushNamed('productDetail', pathParameters: {'id': '$i'}),
        ),
      );
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => Center(child: Text('Product $id'));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile'));
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => HomeController());
  }
}

// ---- Building the router with the package ----
final appRouter = buildShellRouter(
  initialLocation: '/home',
  destinations: const [
    AppNavDestination(icon: Icon(Icons.home), label: 'Home'),
    AppNavDestination(icon: Icon(Icons.person), label: 'Profile'),
  ],
  onRootBackPressed: () {
    // For example, show an exit confirmation dialog
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
