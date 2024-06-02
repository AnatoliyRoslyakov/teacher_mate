import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/pages/home_page.dart';
import 'package:collection/collection.dart';
import 'package:teacher_mate/src/pages/login_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  //  final GlobalKey<NavigatorState> _shellNavigatorKey =
  // GlobalKey<NavigatorState>();

  GoRouter router() {
    return GoRouter(
      initialLocation: MobileRoutes.login.path,
      navigatorKey: rootNavigatorKey,
      routes: <RouteBase>[
        GoRoute(
          name: MobileRoutes.home.name,
          path: MobileRoutes.home.path,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          name: MobileRoutes.login.name,
          path: MobileRoutes.login.path,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
      ],
    );
  }
}

enum MobileRoutes {
  login,
  home;

  static MobileRoutes? fromName(String? name) {
    return MobileRoutes.values.firstWhereOrNull(
      (MobileRoutes element) => element.name == name,
    );
  }
}

extension MobileRoutesExt on MobileRoutes {
  String get path => '/$name';
}
