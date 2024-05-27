import 'dart:developer';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      if (state.listLessons.isNotEmpty) {
        log(DateTime.fromMillisecondsSinceEpoch(
                state.listLessons[0].start * 1000)
            .toString());
      }
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
                    lessons: {
                      DateTime(2024, 5, 27): [
                        ...List.generate(
                            state.listLessons.length,
                            (int index) => Lesson(
                                start: DateTime.fromMillisecondsSinceEpoch(
                                    state.listLessons[index].start * 1000),
                                end: DateTime.fromMillisecondsSinceEpoch(
                                    state.listLessons[index].end * 1000),
                                name: index.toString()))
                      ],
                    },
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
