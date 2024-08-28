import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_mate/core/di/injector.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/bloc/config_bloc/config_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/bloc/user_details_bloc/user_details_bloc.dart';
import 'package:teacher_mate/src/config/app_config.dart';
import 'package:teacher_mate/core/router/app_router.dart';
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

final GoRouter router =
    AppRouter(sharedPreferences: injector.get<SharedPreferences>()).router();

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _globalBlocs(),
      child: MultiBlocListener(
        listeners: _globalListeners(),
        child: MaterialApp.router(
          scrollBehavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
    BlocProvider<ConfigBloc>(
      create: (context) =>
          injector.get<ConfigBloc>()..add(const ConfigEvent.init()),
    ),
    BlocProvider<LessonBloc>(
        create: (context) =>
            injector.get<LessonBloc>()..add(const LessonEvent.read())),
    BlocProvider<StudentBloc>(
        create: (context) =>
            injector.get<StudentBloc>()..add(const StudentEvent.read())),
    BlocProvider<SettingsBloc>(
        create: (context) =>
            injector.get<SettingsBloc>()..add(const SettingsEvent.init())),
    BlocProvider<UserDetailsBloc>(
        create: (context) => injector.get<UserDetailsBloc>()
          ..add(const UserDetailsEvent.init())),
  ];
}

List<BlocListener> _globalListeners() {
  return [
    BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.token.isNotEmpty) {
          AppRouter.rootNavigatorKey.currentContext
              ?.goNamed(MobileRoutes.home.name);
          return;
        } else if (state.isFirstStart) {
          AppRouter.rootNavigatorKey.currentContext
              ?.goNamed(MobileRoutes.intro.name);
          return;
        } else {
          AppRouter.rootNavigatorKey.currentContext
              ?.goNamed(MobileRoutes.login.name);
        }
      },
      listenWhen: (previous, current) => previous != current,
    ),
  ];
}
