import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calendar/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/di/injector.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/config/app_config.dart';

void main() async {
  await initInjector(AppConfig());
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            injector.get<CalendarBloc>()..add(const CalendarEvent.read()),
        child: const MaterialApp(home: CalendarBaseWidget()));
  }
}

class CalendarBaseWidget extends StatefulWidget {
  const CalendarBaseWidget({
    super.key,
  });

  @override
  CalendarBaseWidgetState createState() => CalendarBaseWidgetState();
}

class CalendarBaseWidgetState extends State<CalendarBaseWidget> {
  void addLesson({required int start, required int end}) {
    context.read<CalendarBloc>().add(CalendarEvent.create(start, end));
  }

  void deleteLesson({required String id}) {
    context.read<CalendarBloc>().add(CalendarEvent.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      if (state.mapLessons.isNotEmpty) {}
      return Scaffold(
        backgroundColor: Colors.white,
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Calendar(
                    minutesGrid: 0.5,
                    startHour: 9,
                    endHour: 22,
                    lessons: state.mapLessons,
                    addLesson: addLesson,
                    deleteLesson: deleteLesson,
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
