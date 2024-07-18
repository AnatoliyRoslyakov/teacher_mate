import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/core/di/injector.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/config/app_config.dart';
import 'package:teacher_mate/src/router/app_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initInjector(AppConfig());
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final GoRouter router = AppRouter().router();

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _globalBlocs(),
      child: MultiBlocListener(
        listeners: _globalListeners(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        ),
      ),
    );
  }
}

List<BlocProvider> _globalBlocs() {
  return [
    BlocProvider<AuthBloc>(
      create: (context) =>
          injector.get<AuthBloc>()..add(const AuthEvent.init()),
    ),
    BlocProvider<CalendarBloc>(
        create: (context) =>
            injector.get<CalendarBloc>()..add(const CalendarEvent.read())),
    BlocProvider<StudentBloc>(
        create: (context) =>
            injector.get<StudentBloc>()..add(const StudentEvent.read())),
    BlocProvider<SettingsBloc>(
        create: (context) =>
            injector.get<SettingsBloc>()..add(const SettingsEvent.init())),
  ];
}

List<BlocListener> _globalListeners() {
  return [
    BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log(state.token);
        if (state.token.isNotEmpty) {
          AppRouter.rootNavigatorKey.currentContext
              ?.goNamed(MobileRoutes.home.name);
        } else {
          AppRouter.rootNavigatorKey.currentContext
              ?.goNamed(MobileRoutes.login.name);
        }
      },
      listenWhen: (previous, current) => previous != current,
    ),
  ];
}
