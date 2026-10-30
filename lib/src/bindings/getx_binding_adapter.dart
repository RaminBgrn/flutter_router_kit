import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper for using GetX Bindings inside go_router builders.
/// Since go_router has no concept of a Binding (that belongs to GetX), this
/// function calls dependencies() manually before the page is built.
///
/// Usage in any app:
/// ```dart
/// builder: (context, state) => buildWithBinding(
///   binding: HomeBinding(),
///   page: () => const HomePage(),
/// ),
/// ```
Widget buildWithBinding({
  required Bindings binding,
  required Widget Function() page,
}) {
  binding.dependencies();
  return page();
}
