# flutter_router_kit

کیت آماده برای راه‌اندازی go_router با:

- شل ثابت با `StatefulShellRoute.indexedStack`؛ AppBar و BottomNav با تعویض تب rebuild نمی‌شن
- پشتیبانی از nested route داخل هر تب
- مدیریت بک فیزیکی گوشی: اول pop داخل تب فعلی، بعد برگشت به تب اول، و در ریشه‌ی تب اول تحویل به خود اپ
- ناوبری بدون context از داخل Controllerها با `AppNav`
- پشتیبانی از GetX Bindings با `buildWithBinding`

## نصب

```yaml
  flutter_router_kit:
    git:
      url: https://github.com/RaminBgrn/flutter_router_kit.git
      ref: main
```

وابستگی‌ها: `go_router: ^14.0.0` و `get: ^4.6.6`

## استفاده سریع

فقط دو چیز از اپ تو لازمه: branchهای هر تب و آیتم‌های BottomNav.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_router_kit/flutter_router_kit.dart';

final appRouter = buildShellRouter(
  initialLocation: '/home',
  destinations: const [
    AppNavDestination(icon: Icon(Icons.home), label: 'خانه'),
    AppNavDestination(icon: Icon(Icons.person), label: 'پروفایل'),
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

// در اپ:
MaterialApp.router(routerConfig: appRouter);
```

نمونه‌ی کامل‌تر، با route تو‌در‌تو و Binding، در `example/main_usage_example.dart` هست.

## پارامترهای `buildShellRouter`

- `initialLocation` (اجباری): مسیر شروع اپ
- `branches` (اجباری): لیست `StatefulShellBranch`ها، یکی برای هر تب
- `destinations` (اجباری): آیتم‌های BottomNav از نوع `AppNavDestination` شامل `icon` و `label` و `selectedIcon` اختیاری
- `outsideRoutes`: routeهای بیرون از شل، مثل صفحه‌ی لاگین
- `rootNavigatorKey`: کلید Navigator ریشه؛ اگه ندی خودش ساخته می‌شه. برای استفاده از `AppNav` همین کلید رو باید بهش بدی (بخش بعد)
- `appBarBuilder`: ساخت AppBar سفارشی بر اساس ایندکس تب فعلی؛ اگه ندی یه AppBar پیش‌فرض با عنوان تب فعلی ساخته می‌شه
- `onRootBackPressed`: وقتی کاربر در ریشه‌ی تب اول بک فیزیکی می‌زنه و جایی برای pop نیست، این callback صدا زده می‌شه تا خود اپ تصمیم بگیره (مثلاً دیالوگ تأیید خروج)

## ناوبری بدون context با `AppNav`

داخل GetX Controllerها به BuildContext دسترسی نداری. `AppNav` با همون `rootNavigatorKey`، context رو می‌گیره و این کارها رو انجام می‌ده:

- `AppNav.goNamed(name)` و `AppNav.pushNamed(name)` با `pathParameters` و `extra`
- `AppNav.go(path)`، `AppNav.pop()` و `AppNav.canPop()`
- `AppNav.dialog(...)`، `AppNav.generalDialog(...)` و `AppNav.bottomSheet(...)` معادل توابع خود فلاتر

قبل از استفاده، یک بار موقع ساخت روتر init کن:

```dart
final rootKey = GlobalKey<NavigatorState>();

AppNav.init(rootKey);

final appRouter = buildShellRouter(
  rootNavigatorKey: rootKey,
  // ...
);
```

## استفاده از GetX Binding در routeها

go_router مفهوم Binding رو نمی‌شناسه، پس داخل builder صدا بزن:

```dart
GoRoute(
  path: '/home',
  builder: (context, state) => buildWithBinding(
    binding: HomeBinding(),
    page: () => const HomePage(),
  ),
)
```
