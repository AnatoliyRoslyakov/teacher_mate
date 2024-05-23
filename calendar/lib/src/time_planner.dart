import 'dart:ui';

import 'package:calendar/calendar_page.dart';
import 'package:calendar/main.dart';

import 'package:flutter/material.dart';
import 'package:calendar/src/config/global_config.dart' as config;
import 'package:calendar/src/time_planner_style.dart';

import 'package:calendar/src/time_planner_time.dart';

import 'package:intl/intl.dart';

/// Time planner widget
class TimePlanner extends StatefulWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final Map<DateTime, List<Lesson>>? lessons;

  final TimePlannerStyle? style;

  const TimePlanner({
    Key? key,
    required this.startHour,
    required this.endHour,
    this.lessons,
    this.style,
    required this.minutesGrid,
  }) : super(key: key);
  @override
  _TimePlannerState createState() => _TimePlannerState();
}

class _TimePlannerState extends State<TimePlanner> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  bool? isAnimated = true;

  DateTime currentTime = DateTime.now();

  void prevWeek() {
    setState(() {
      currentTime = currentTime.subtract(const Duration(days: 7));
    });
  }

  void nextWeek() {
    setState(() {
      currentTime = currentTime.add(const Duration(days: 7));
    });
  }

  List<List<Lesson>> get lessonsData {
    final startTime = currentTime.startOfCurrentWeek().startOfDay();
    final result = <List<Lesson>>[[]];
    for (int i = 0; i < 7; i++) {
      result.add(widget.lessons?[startTime.add(Duration(days: i))] ?? []);
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mainHorizontalController.addListener(() {
      dayHorizontalController.jumpTo(mainHorizontalController.offset);
    });
    mainVerticalController.addListener(() {
      timeVerticalController.jumpTo(mainVerticalController.offset);
    });

    final startTime = currentTime.startOfCurrentWeek();
    return Column(
      children: [
        DateRangeWidget(
          nextDate: () {
            nextWeek();
          },
          afterDate: () {
            prevWeek();
          },
        ),
        const SizedBox(
          height: 40,
        ),
        Row(children: [
          SizedBox(
            width: 60,
          ),
          ...List.generate(7, (index) {
            final time = DateFormat('E dd.MM')
                .format(startTime.add(Duration(days: index)));
            return Expanded(
                child: Center(
              child: Text(
                time,
              ),
            ));
          }),
        ]),
        Expanded(
          child: SingleChildScrollView(
            controller: mainVerticalController,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TimeIntervalsWidget(
                            startHour: widget.startHour,
                            endHour: widget.endHour,
                            minutesGrid: widget.minutesGrid),
                      ),
                      ...List.generate(
                          7,
                          (index) => Expanded(
                                  child: ColumnDayWidget(
                                lessons: lessonsData[index + 1],
                                startHour: widget.startHour,
                                endHour: widget.endHour,
                                minutesGrid: widget.minutesGrid,
                              ))),
                    ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void showBlurredDialog(
  BuildContext context,
  DateTime initialStartTime,
  DateTime initialEndTime,
) {
  final TextEditingController textController = TextEditingController();

  String selectedTime = '';

  String formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String formattedHour = hour.toString().padLeft(2, '0');
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width - 100,
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
                      Text('Диалоговое окно', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Введите текст',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: initialStartTime.hour,
                                minute: initialStartTime.minute),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime =
                                  'Начальное время: ${formatTimeOfDay(picked)}';
                            });
                          }
                        },
                        child: Text('Выберите начальное время'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: initialEndTime.hour,
                                minute: initialEndTime.minute),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime +=
                                  ', Время окончания: ${formatTimeOfDay(picked)}';
                            });
                          }
                        },
                        child: Text('Выберите время окончания'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        selectedTime,
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Закрыть'),
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
