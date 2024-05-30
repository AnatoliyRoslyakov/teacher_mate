import 'package:calendar/calendar.dart';
import 'package:calendar/src/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarDaysSection extends StatefulWidget {
  final List<LessonEntity> lessons;
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final int dayIndex;
  final DateTime currentTime;
  final int viewDay;
  final bool startOfWeek;
  final double size;
  final void Function({required int start, required int end}) addLesson;
  final void Function({required String id}) deleteLesson;

  const CalendarDaysSection({
    super.key,
    required this.lessons,
    required this.startHour,
    required this.endHour,
    required this.minutesGrid,
    required this.addLesson,
    required this.dayIndex,
    required this.currentTime,
    required this.deleteLesson,
    required this.viewDay,
    required this.startOfWeek,
    required this.size,
  });

  @override
  State<CalendarDaysSection> createState() => _CalendarDaysSectionState();
}

class _CalendarDaysSectionState extends State<CalendarDaysSection> {
  @override
  Widget build(BuildContext context) {
    final start = widget.startOfWeek
        ? widget.currentTime
            .startOfCurrentWeek()
            .copyWith(hour: widget.startHour)
        : widget.currentTime.copyWith(hour: widget.startHour);
    final end = widget.startOfWeek
        ? widget.currentTime.startOfCurrentWeek().copyWith(hour: widget.endHour)
        : widget.currentTime.copyWith(hour: widget.endHour);
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
                  duration: const Duration(milliseconds: 300),
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
                            start.add(Duration(days: widget.dayIndex)).copyWith(
                                hour: widget.minutesGrid == 0.5
                                    ? widget.startHour + index ~/ 2
                                    : widget.startHour + index,
                                minute:
                                    widget.minutesGrid == 0.5 && index % 2 != 0
                                        ? 30
                                        : 00),
                            end.add(Duration(days: widget.dayIndex)).copyWith(
                                hour: widget.minutesGrid == 0.5
                                    ? widget.startHour + (index + 1) ~/ 2
                                    : widget.startHour + (index + 1),
                                minute: widget.minutesGrid == 0.5 &&
                                        (index + 1) % 2 != 0
                                    ? 30
                                    : 00),
                            widget.addLesson);
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
            final top = (start - widget.startHour * 60.0) * 2;
            final height = (end - start).toDouble();
            return Positioned(
                top: top,
                child: Center(
                  child: InkWell(
                    hoverColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      widget.deleteLesson(id: lesson.name);
                    },
                    child: SizedBox(
                      width:
                          (widget.size / widget.viewDay) - 100 / widget.viewDay,
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
                            width: (widget.size / widget.viewDay) -
                                100 / widget.viewDay -
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
