import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/pages/mobile/cupertino_modal_sheet_page.dart';
import 'package:teacher_mate/src/screen/create_lesson_screen.dart';
import 'package:teacher_mate/src/screen/home_screen.dart';
import 'package:collection/collection.dart';
import 'package:teacher_mate/src/screen/login_screen.dart';

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
          name: MobileRoutes.create.name,
          path: MobileRoutes.create.path,
          pageBuilder: (context, state) => CupertinoModalSheetPage<void>(
            builder: (context) => const CreateLessonScreen(),
          ),
        ),
        GoRoute(
          name: MobileRoutes.home.name,
          path: MobileRoutes.home.path,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          name: MobileRoutes.login.name,
          path: MobileRoutes.login.path,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
      ],
    );
  }
}

enum MobileRoutes {
  login,
  create,
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
