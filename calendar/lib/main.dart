import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:calendar/calendar_page.dart';
import 'package:calendar/src/logic/calendar_bloc.dart';
import 'package:calendar/time_planner.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
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
    return const MaterialApp(home: CalendarBaseWidget()
        // CalendarPage(),

        );
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
  List<CalendarTask> tasks = [];
  String formattedDate = '';
  DateTime startDate = DateTime.now();

  List<CalendarTask> createTaskMap(List<CalendarTask> tasks) {
    return tasks;
  }

  String formatDate({required int day, required DateTime startTime}) {
    DateTime now = startTime.add(Duration(days: day));
    String formattedDayOfWeek = DateFormat.EEEE().format(now).substring(0, 2);
    String formattedDateOfMonth = DateFormat.d().format(now);
    return '$formattedDateOfMonth $formattedDayOfWeek';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            DateRangeWidget(
              nextDate: () {
                setState(() {
                  startDate = startDate.add(const Duration(days: 6));
                  log(startDate.toString());
                });
              },
              afterDate: () {
                setState(() {
                  startDate = startDate.subtract(const Duration(days: 6));
                  log(startDate.toString());
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: TimePlanner(
                  startHour: 7,
                  endHour: 23,
                  use24HourFormat: true,
                  setTimeOnAxis: true,
                  style: TimePlannerStyle(
                    dividerColor: Colors.grey,
                    showScrollBar: true,
                    interstitialEvenColor: Colors.grey[50],
                    interstitialOddColor: Colors.grey[150],
                  ),
                  headers: [
                    ...List.generate(10, (int day) {
                      return TimePlannerTitle(
                          title: formatDate(day: day, startTime: startDate)
                              .toLowerCase());
                    })
                  ],
                  tasks: [
                    CalendarTask(
                        minutesDuration: 60,
                        dateTime: DateTaskStart(
                            day: 1,
                            hour: 10,
                            minutes: 10,
                            year: 2024,
                            month: 5),
                        title: 'title'),
                    CalendarTask(
                        minutesDuration: 30,
                        dateTime: DateTaskStart(
                            day: 2,
                            hour: 11,
                            minutes: 10,
                            year: 2024,
                            month: 5),
                        title: 'title'),
                    CalendarTask(
                        minutesDuration: 90,
                        dateTime: DateTaskStart(
                            day: 3,
                            hour: 12,
                            minutes: 10,
                            year: 2024,
                            month: 5),
                        title: 'title')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTaskMap([
          CalendarTask(
              minutesDuration: 60,
              dateTime: DateTaskStart(
                  day: 20, hour: 10, minutes: 10, year: 2024, month: 5),
              title: 'title'),
          CalendarTask(
              minutesDuration: 30,
              dateTime: DateTaskStart(
                  day: 25, hour: 11, minutes: 10, year: 2024, month: 5),
              title: 'title'),
          CalendarTask(
              minutesDuration: 90,
              dateTime: DateTaskStart(
                  day: 27, hour: 12, minutes: 10, year: 2024, month: 5),
              title: 'title')
        ]),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DateRangeWidget extends StatefulWidget {
  final VoidCallback nextDate;
  final VoidCallback afterDate;

  const DateRangeWidget({required this.nextDate, required this.afterDate});
  @override
  _DateRangeWidgetState createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  DateTime _selectedDate = DateTime.now();

  void _updateDate(bool isForward) {
    setState(() {
      _selectedDate = isForward
          ? _selectedDate.add(Duration(days: 6))
          : _selectedDate.subtract(Duration(days: 6));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = _selectedDate;
    DateTime endDate = _selectedDate.add(const Duration(days: 6));

    String formattedStartDate =
        DateFormat('dd MMM').format(startDate).toLowerCase();
    String formattedEndDate =
        DateFormat('dd MMM').format(endDate).toLowerCase();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                widget.afterDate.call();

                _updateDate(false);
              },
            ),
            Text(
              '$formattedStartDate - $formattedEndDate',
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                widget.nextDate.call();
                _updateDate(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
