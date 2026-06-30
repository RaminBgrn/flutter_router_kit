import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// تابع کمکی برای استفاده از GetX Bindings داخل builder های go_router.
/// چون go_router مفهوم Binding نمی‌شناسه (مال GetX هست)، با این تابع
/// قبل از ساخته شدن صفحه، دستی dependencies() رو صدا می‌زنیم.
///
/// استفاده در هر اپ:
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
