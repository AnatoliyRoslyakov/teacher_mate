import 'package:calendar/time_planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ColumnDayWidget extends StatefulWidget {
  final List<Lesson> lessons;
  final int startHour;
  final int endHour;
  final double minutesGrid;

  const ColumnDayWidget({
    super.key,
    required this.lessons,
    required this.startHour,
    required this.endHour,
    required this.minutesGrid,
  });

  @override
  State<ColumnDayWidget> createState() => _ColumnDayWidgetState();
}

class _ColumnDayWidgetState extends State<ColumnDayWidget> {
  @override
  Widget build(BuildContext context) {
    print('+');
    final start = DateTime.now().copyWith(hour: widget.startHour);
    final end = DateTime.now().copyWith(hour: widget.endHour);
    final count = (end.hour - start.hour) ~/ widget.minutesGrid;
    return SizedBox(
      height: count * widget.minutesGrid * 120,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: SizedBox(
            height: widget.minutesGrid * 120 * count,
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 100,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: List.generate(count, (index) {
                    return InkWell(
                      hoverColor: Colors.amber,
                      onTap: () {
                        showBlurredDialog(
                            context,
                            start.copyWith(
                                hour: widget.minutesGrid == 0.5
                                    ? widget.startHour + index ~/ 2
                                    : widget.startHour + index,
                                minute:
                                    widget.minutesGrid == 0.5 && index % 2 != 0
                                        ? 30
                                        : 00),
                            end.copyWith(
                                hour: widget.minutesGrid == 0.5
                                    ? widget.startHour + (index + 1) ~/ 2
                                    : widget.startHour + (index + 1),
                                minute: widget.minutesGrid == 0.5 &&
                                        (index + 1) % 2 != 0
                                    ? 30
                                    : 00));
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: widget.minutesGrid * 120,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.5)),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )),
          ...List.generate(widget.lessons.length, (index) {
            final lesson = widget.lessons[index];
            final start = lesson.start.hour * 60 + lesson.start.minute;
            final end = lesson.end.hour * 60 + lesson.end.minute;
            final top = (start - 9 * 60.0) * 2;
            final height = (end - start).toDouble();
            return Positioned(
                top: top,
                child: Center(
                  child: InkWell(
                    hoverColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      print(lesson.name);
                    },
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width / 7) - 100 / 7,
                      height: height * 2,
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)),
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            height: height * 2,
                            width: (MediaQuery.of(context).size.width / 7) -
                                100 / 7 -
                                5,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7),
                                  bottomRight: Radius.circular(7)),
                              color: Colors.blue.withOpacity(0.6),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                children: [
                                  Text(
                                      '${lesson.start.hour}:${lesson.start.minute}-${lesson.end.hour}:${lesson.end.minute}'),
                                  Text(
                                    lesson.name,
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }),
        ],
      ),
    );
  }
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
