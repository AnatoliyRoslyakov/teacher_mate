import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calendar/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/di/injector.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/config/app_config.dart';
import 'package:teacher_mate/src/entity/calendar_settings.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => injector.get<CalendarBloc>()
                ..add(const CalendarEvent.read())),
          BlocProvider(
              create: (context) =>
                  injector.get<StudentBloc>()..add(const StudentEvent.read())),
        ],
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: CalendarBaseWidget()));
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
  void addLesson(
      {required int start,
      required int end,
      required int type,
      required int studentId}) {
    context
        .read<CalendarBloc>()
        .add(CalendarEvent.create(start, end, type, studentId));
  }

  void deleteLesson({required String id}) {
    context.read<CalendarBloc>().add(CalendarEvent.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return BlocBuilder<StudentBloc, StudentState>(
          builder: (context, stateStudent) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: CalendarSettingsWidget(
              calendarSettings: state.calendarSettings,
            ),
            backgroundColor: Colors.white,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        flex: 2,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Calendar(
                                minutesGrid: state.calendarSettings.minutesGrid,
                                startHour: state.calendarSettings.startHour,
                                endHour: state.calendarSettings.endHour,
                                viewDay: state.calendarSettings.viewDay,
                                lessons: state.mapLessons,
                                addLesson: addLesson,
                                deleteLesson: deleteLesson,
                                student: stateStudent.studentEntity,
                                // если true -> viewDay = 7 (начало: понедельник)
                                startOfWeek:
                                    state.calendarSettings.startOfWeek),
                          ),
                        ),
                      ),
                stateStudent.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              width: 2,
                              height: double.infinity,
                              color: Colors.grey[200],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 55,
                                  ),
                                  const Text(
                                    'List of students',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3 -
                                            42,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount:
                                          stateStudent.studentEntity.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.amber),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(stateStudent
                                                    .studentEntity[i].name),
                                                Text(
                                                    'price: ${stateStudent.studentEntity[i].price}р'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          overlayColor: Colors.amber,
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3 -
                                                  42,
                                              45)),
                                      onPressed: () {
                                        showBlurredDialog(context);
                                      },
                                      child: const Icon(Icons.add))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(Icons.settings),
            ),
          ),
        );
      });
    });
  }
}

void showBlurredDialog(
  BuildContext context,
) {
  bool isValid = true;
  String name = '';
  int price = 0;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          isValid = name.isNotEmpty && price >= 0;
          return Dialog(
            insetAnimationCurve: Curves.linear,
            insetAnimationDuration: const Duration(milliseconds: 500),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Student', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a name',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Lesson amount', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            price = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the amount',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (isValid) {
                            context
                                .read<StudentBloc>()
                                .add(StudentEvent.create(name, price));
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class CalendarSettingsWidget extends StatefulWidget {
  final CalendarSettingsEntity calendarSettings;

  const CalendarSettingsWidget({super.key, required this.calendarSettings});
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
  void initState() {
    minutesGrid = widget.calendarSettings.minutesGrid;
    startHour = widget.calendarSettings.startHour;
    endHour = widget.calendarSettings.endHour;
    viewDay = widget.calendarSettings.viewDay;
    startOfWeek = widget.calendarSettings.startOfWeek;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 350,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Setting up a calendar',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grid (minutes):'),
                  DropdownButton<double>(
                    value: minutesGrid,
                    items: const [
                      DropdownMenuItem(
                        value: 0.5,
                        child: Text('30 minutes'),
                      ),
                      DropdownMenuItem(
                        value: 1.0,
                        child: Text('60 minutes'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start day:'),
                  DropdownButton<int>(
                    value: startHour,
                    items: List.generate(16, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('$index'),
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
                  const Text('End day:'),
                  DropdownButton<int>(
                    value: endHour,
                    items: List.generate(8, (index) {
                      return DropdownMenuItem(
                        value: 16 + index,
                        child: Text('${16 + index}'),
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
                  const Text('Number of days:'),
                  DropdownButton<int>(
                    value: viewDay,
                    items: List.generate(15, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start on Monday:'),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<CalendarBloc>().add(CalendarEvent.settings(
                      minutesGrid, startHour, endHour, viewDay, startOfWeek));
                },
                child: const Text('Save settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
