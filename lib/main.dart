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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void addLesson({required int start, required int end}) {
    context.read<CalendarBloc>().add(CalendarEvent.create(start, end));
  }

  void deleteLesson({required String id}) {
    context.read<CalendarBloc>().add(CalendarEvent.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CalendarSettingsWidget(),
        backgroundColor: Colors.white,
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Calendar(
                      minutesGrid: 0.5,
                      startHour: 1,
                      endHour: 23,
                      viewDay: 4,
                      lessons: state.mapLessons,
                      addLesson: addLesson,
                      deleteLesson: deleteLesson,
                      startOfWeek:
                          false // если true -> viewDay = 7 (начало: понедельник)
                      ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            Scaffold.of(context).openDrawer();
            // showBlurredDialog(
            //     context,
            //     DateTime.now().copyWith(minute: 0),
            //     DateTime.now()
            //         .copyWith(minute: 0)
            //         .add(const Duration(hours: 1)),
            //     addLesson);
          },
          child: const Icon(Icons.settings),
        ),
      );
    });
  }
}

class CalendarSettingsWidget extends StatefulWidget {
  @override
  _CalendarSettingsWidgetState createState() => _CalendarSettingsWidgetState();
}

class _CalendarSettingsWidgetState extends State<CalendarSettingsWidget> {
  double minutesGrid = 1.0;
  int startHour = 9;
  int endHour = 22;
  int viewDay = 7;
  bool startOfWeek = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Градация сетки (минуты):'),
                    DropdownButton<double>(
                      value: minutesGrid,
                      items: [
                        DropdownMenuItem(
                          child: Text('30 минут'),
                          value: 0.5,
                        ),
                        DropdownMenuItem(
                          child: Text('60 минут'),
                          value: 1.0,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          minutesGrid = value!;
                        });
                      },
                    ),
                  ],
                ),
                // Start Hour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Начало дня:'),
                    DropdownButton<int>(
                      value: startHour,
                      items: List.generate(16, (index) {
                        return DropdownMenuItem(
                          child: Text('${index}'),
                          value: index,
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          startHour = value!;
                        });
                      },
                    ),
                  ],
                ),
                // End Hour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Конец дня:'),
                    DropdownButton<int>(
                      value: endHour,
                      items: List.generate(8, (index) {
                        return DropdownMenuItem(
                          child: Text('${16 + index}'),
                          value: 16 + index,
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          endHour = value!;
                        });
                      },
                    ),
                  ],
                ),
                // View Day
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Количество дней:'),
                    DropdownButton<int>(
                      value: viewDay,
                      items: List.generate(15, (index) {
                        return DropdownMenuItem(
                          child: Text('${index + 1}'),
                          value: index + 1,
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          viewDay = value!;
                        });
                      },
                    ),
                  ],
                ),
                // Start of Week
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Начинать с понедельника:'),
                    Switch(
                      value: startOfWeek,
                      onChanged: (value) {
                        setState(() {
                          startOfWeek = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Сохранение настроек
                    print('Настройки сохранены:');
                    print('Градация сетки: $minutesGrid');
                    print('Начало дня: $startHour');
                    print('Конец дня: $endHour');
                    print('Количество дней: $viewDay');
                    print('Начинать с понедельника: $startOfWeek');
                  },
                  child: Text('Сохранить настройки'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
