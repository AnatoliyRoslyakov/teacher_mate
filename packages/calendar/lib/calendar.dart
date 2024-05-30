import 'package:calendar/src/calendar_date_range_section.dart';
import 'package:calendar/src/calendar_days_section.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/calendar_time_section.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final Map<DateTime, List<LessonEntity>>? lessons;
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

  List<List<LessonEntity>> get lessonsData {
    final startTime = widget.startOfWeek
        ? currentTime.startOfCurrentWeek().startOfDay()
        : currentTime.startOfDay();
    final result = <List<LessonEntity>>[[]];
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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
                                  size: constraints.maxWidth,
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
    });
  }
}

class LessonEntity {
  final DateTime start;
  final DateTime end;
  final String name;
  final int studentId;
  final int type;
  final int id;

  LessonEntity(
      {required this.studentId,
      required this.type,
      required this.id,
      required this.start,
      required this.end,
      required this.name});
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
