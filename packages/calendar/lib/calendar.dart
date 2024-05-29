import 'package:calendar/src/calendar_date_range_section.dart';
import 'package:calendar/src/calendar_days_section.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/calendar_time_section.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final Map<DateTime, List<Lesson>>? lessons;
  final int viewDay;
  final bool startOfWeek;
  final void Function({required int start, required int end}) addLesson;
  final void Function({required String id}) deleteLesson;

  const Calendar({
    super.key,
    required this.startHour,
    required this.endHour,
    this.lessons,
    required this.minutesGrid,
    required this.addLesson,
    required this.deleteLesson,
    required this.viewDay,
    required this.startOfWeek,
  });
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  bool? isAnimated = true;

  DateTime currentTime = DateTime.now();
  int viewDay = 7;

  void currentWeek() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  void prevWeek() {
    setState(() {
      currentTime = currentTime.subtract(
          Duration(days: widget.startOfWeek ? viewDay : widget.viewDay));
    });
  }

  void nextWeek() {
    setState(() {
      currentTime = currentTime
          .add(Duration(days: widget.startOfWeek ? viewDay : widget.viewDay));
    });
  }

  List<List<Lesson>> get lessonsData {
    final startTime = widget.startOfWeek
        ? currentTime.startOfCurrentWeek().startOfDay()
        : currentTime.startOfDay();
    final result = <List<Lesson>>[[]];
    for (int i = 0; i < (widget.startOfWeek ? viewDay : widget.viewDay); i++) {
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
    final startTime =
        widget.startOfWeek ? currentTime.startOfCurrentWeek() : currentTime;
    return Column(
      children: [
        DateRangeSection(
            nextDate: () {
              nextWeek();
            },
            afterDate: () {
              prevWeek();
            },
            viewDay: widget.startOfWeek ? viewDay : widget.viewDay,
            startOfWeek: widget.startOfWeek),
        // const SizedBox(
        //   height: 40,
        // ),
        Row(children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: IconButton(
                  onPressed: () {
                    currentWeek();
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                  )),
            ),
          ),
          ...List.generate(widget.startOfWeek ? viewDay : widget.viewDay,
              (index) {
            final time =
                DateFormat(widget.viewDay > 10 ? 'E\ndd.MM' : 'E dd.MM')
                    .format(startTime.add(Duration(days: index)));
            return Expanded(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    time,
                  ),
                ),
              ),
            ));
          }),
        ]),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: CalendarTimeSection(
                            startHour: widget.startHour,
                            endHour: widget.endHour,
                            minutesGrid: widget.minutesGrid),
                      ),
                      ...List.generate(
                          widget.startOfWeek ? viewDay : widget.viewDay,
                          (index) => Expanded(
                                  child: CalendarDaysSection(
                                startOfWeek: widget.startOfWeek,
                                viewDay: widget.startOfWeek
                                    ? viewDay
                                    : widget.viewDay,
                                currentTime: currentTime,
                                dayIndex: index,
                                lessons: lessonsData[index + 1],
                                startHour: widget.startHour,
                                endHour: widget.endHour,
                                minutesGrid: widget.minutesGrid,
                                addLesson: widget.addLesson,
                                deleteLesson: widget.deleteLesson,
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
  final void Function({required int start, required int end}) onTap,
) {
  final TextEditingController textController = TextEditingController();

  String selectedTimeStart =
      'Начальное время: \n ${DateFormat('HH:mm').format(initialStartTime)}';
  String selectedTimeEnd =
      'Время окончания: \n ${DateFormat('HH:mm').format(initialEndTime)}';

  bool isValid = true;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      int start = initialStartTime.millisecondsSinceEpoch;
      int end = initialEndTime.millisecondsSinceEpoch;
      return StatefulBuilder(
        builder: (context, setState) {
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
                      Text('Создать урок', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
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
                              selectedTimeStart =
                                  'Начальное время: \n ${DateFormat('HH:mm').format(initialStartTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                              start = initialStartTime
                                  .copyWith(
                                      hour: picked.hour, minute: picked.minute)
                                  .millisecondsSinceEpoch;
                              isValid = true;
                              if (start >= end) {
                                isValid = false;
                              }
                            });
                          }
                        },
                        child: Text(
                          selectedTimeStart,
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.red),
                          textAlign: TextAlign.center,
                        ),
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
                              selectedTimeEnd =
                                  'Время окончания: \n ${DateFormat('HH:mm').format(initialEndTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                              end = initialEndTime
                                  .copyWith(
                                      hour: picked.hour, minute: picked.minute)
                                  .millisecondsSinceEpoch;
                              isValid = true;
                              if (start >= end) {
                                isValid = false;
                              }
                            });
                          }
                        },
                        child: Text(
                          selectedTimeEnd,
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (isValid) {
                            onTap.call(start: start, end: end);
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

class Lesson {
  final DateTime start;
  final DateTime end;
  final String name;

  Lesson({required this.start, required this.end, required this.name});
}

extension DateTimeExt on DateTime {
  DateTime get monthStart {
    return DateTime(year, month);
  }

  DateTime nextMonth() {
    if (month == DateTime.december) {
      return DateTime(year + 1);
    }
    return DateTime(year, month + 1);
  }

  DateTime prevMonth() {
    if (month == DateTime.january) {
      return DateTime(year - 1, DateTime.december);
    }
    return DateTime(year, month - 1);
  }

  DateTime startOfCurrentWeek() {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime lastDayOfWeek() {
    return add(Duration(days: 7 - weekday));
  }

  DateTime endOfCurrentMonth() {
    return nextMonth().subtract(const Duration(microseconds: 1)).startOfDay();
  }

  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
