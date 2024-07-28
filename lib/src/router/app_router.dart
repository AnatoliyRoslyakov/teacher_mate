import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/pages/mobile/cupertino_modal_sheet_page.dart';
import 'package:teacher_mate/src/screen/create_lesson_screen.dart';
import 'package:teacher_mate/src/screen/home_screen.dart';
import 'package:collection/collection.dart';
import 'package:teacher_mate/src/screen/login_screen.dart';
import 'package:teacher_mate/src/screen/settings_screen.dart';
import 'package:teacher_mate/src/screen/student_screen.dart';

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
            pageBuilder: (context, state) {
              final DateTime initialStartTime =
                  (state.extra as Map)['initialStartTime'];
              final DateTime initialEndTime =
                  (state.extra as Map)['initialEndTime'];
              final bool edit = (state.extra as Map)['edit'];
              final String description = (state.extra as Map)['description'];
              final int selectedType = (state.extra as Map)['selectedType'];
              final int studentId = (state.extra as Map)['studentId'];
              final int lessonId = (state.extra as Map)['lessonId'];

              return CupertinoModalSheetPage<void>(
                builder: (context) => CreateLessonScreen(
                  initialStartTime: initialStartTime,
                  initialEndTime: initialEndTime,
                  edit: edit,
                  description: description,
                  selectedType: selectedType,
                  studentId: studentId,
                  lessonId: lessonId,
                ),
              );
            }),
        GoRoute(
            name: MobileRoutes.settings.name,
            path: MobileRoutes.settings.path,
            pageBuilder: (context, state) {
              return CupertinoModalSheetPage<void>(
                builder: (context) => const SettingsScreen(),
              );
            }),
        GoRoute(
            name: MobileRoutes.students.name,
            path: MobileRoutes.students.path,
            pageBuilder: (context, state) {
              return CupertinoModalSheetPage<void>(
                builder: (context) => const StudentScreen(),
              );
            }),
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
  settings,
  students,
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
