import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/core/di/injector.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/config/app_config.dart';
import 'package:teacher_mate/src/router/app_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
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
      providers: [
        BlocProvider(
            create: (context) =>
                injector.get<CalendarBloc>()..add(const CalendarEvent.read())),
        BlocProvider(
            create: (context) =>
                injector.get<StudentBloc>()..add(const StudentEvent.read())),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),

      //  const MaterialApp(
      //     debugShowCheckedModeBanner: false, home: CalendarBaseWidget()));
    );
  }
}
