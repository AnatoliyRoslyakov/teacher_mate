import 'dart:ui';
import 'package:calendar/calendar_page.dart';
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
    return const MaterialApp(home: CalendarBaseWidget());
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: TimePlanner(
            minutesGrid: 0.5,
            startHour: 9,
            endHour: 22,
            style: TimePlannerStyle(
              dividerColor: Colors.grey,
              showScrollBar: true,
              interstitialEvenColor: Colors.grey[50],
              interstitialOddColor: Colors.grey[150],
            ),
            lessons: {
              DateTime(2024, 5, 20): [
                Lesson(
                    start: DateTime(2024, 5, 20, 14, 00),
                    end: DateTime(2024, 5, 20, 15, 00),
                    name: 'Евгений'),
                Lesson(
                    start: DateTime(2024, 5, 20, 15, 00),
                    end: DateTime(2024, 5, 20, 15, 30),
                    name: 'Алеся'),
                Lesson(
                    start: DateTime(2024, 5, 20, 15, 30),
                    end: DateTime(2024, 5, 20, 16, 00),
                    name: 'Василий')
              ],
              DateTime(2024, 5, 21): [
                Lesson(
                    start: DateTime(2024, 5, 21, 14, 00),
                    end: DateTime(2024, 5, 21, 15, 00),
                    name: 'Елена (США)'),
                Lesson(
                    start: DateTime(2024, 5, 21, 15, 00),
                    end: DateTime(2024, 5, 21, 15, 30),
                    name: 'Таня'),
                Lesson(
                    start: DateTime(2024, 5, 21, 15, 30),
                    end: DateTime(2024, 5, 21, 16, 00),
                    name: 'Пробный с к'),
                Lesson(
                    start: DateTime(2024, 5, 21, 16, 00),
                    end: DateTime(2024, 5, 21, 16, 30),
                    name: 'Василий')
              ],
              DateTime(2024, 5, 22): [
                Lesson(
                    start: DateTime(2024, 5, 21, 15, 00),
                    end: DateTime(2024, 5, 21, 15, 30),
                    name: 'Sprint Calendar')
              ],
              DateTime(2024, 5, 23): [
                Lesson(
                    start: DateTime(2024, 5, 23, 14, 00),
                    end: DateTime(2024, 5, 23, 15, 30),
                    name: 'Евгений'),
                Lesson(
                    start: DateTime(2024, 5, 23, 15, 00),
                    end: DateTime(2024, 5, 23, 15, 30),
                    name: 'Алеся'),
                Lesson(
                    start: DateTime(2024, 5, 23, 17, 30),
                    end: DateTime(2024, 5, 23, 21, 00),
                    name: 'Василий')
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
  }
}

class DateRangeWidget extends StatefulWidget {
  final VoidCallback nextDate;
  final VoidCallback afterDate;

  const DateRangeWidget(
      {super.key, required this.nextDate, required this.afterDate});
  @override
  _DateRangeWidgetState createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  DateTime _selectedDate = DateTime.now().startOfCurrentWeek();

  void _updateDate(bool isForward) {
    setState(() {
      _selectedDate = isForward
          ? _selectedDate.add(const Duration(days: 7))
          : _selectedDate.subtract(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = _selectedDate;
    DateTime endDate = _selectedDate.add(const Duration(days: 6));
    String formattedStartDate = DateFormat('dd MMM').format(startDate);
    String formattedEndDate = DateFormat('dd MMM').format(endDate);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.afterDate.call();

                _updateDate(false);
              },
            ),
            Text(
              '$formattedStartDate - $formattedEndDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
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
