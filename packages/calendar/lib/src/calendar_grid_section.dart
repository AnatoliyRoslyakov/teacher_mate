import 'dart:async';

import 'package:calendar/calendar.dart';
import 'package:calendar/src/event_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarGridSection extends StatefulWidget {
  final List<LessonEntity> lessons;
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final int dayIndex;
  final DateTime currentTime;
  final List<StudentEntity> student;
  final int viewDay;
  final bool startOfWeek;
  final bool threeDays;
  final double size;
  final bool mobile;
  final bool isLoading;
  final void Function(
      {required BuildContext context,
      required DateTime initialStartTime,
      required DateTime initialEndTime,
      bool edit,
      String description,
      int selectedType,
      int studentId,
      int lessonId}) createLesson;

  const CalendarGridSection({
    super.key,
    required this.lessons,
    required this.startHour,
    required this.endHour,
    required this.minutesGrid,
    required this.dayIndex,
    required this.currentTime,
    required this.viewDay,
    required this.startOfWeek,
    required this.size,
    required this.student,
    required this.mobile,
    required this.createLesson,
    required this.threeDays,
    required this.isLoading,
  });

  @override
  State<CalendarGridSection> createState() => _CalendarGridSectionState();
}

class _CalendarGridSectionState extends State<CalendarGridSection> {
  double top = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculateTop();
    _startTimer();
  }

  void _calculateTop() {
    top = ((DateTime.now().hour - widget.startHour) *
            2 *
            widget.minutesGrid *
            (widget.minutesGrid == 1 ? 60 : 120)) +
        DateTime.now().minute * 2;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 120), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _calculateTop();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
            child: Column(
              children: List.generate(count, (index) {
                // int weekdayIndex =
                //     start.add(Duration(days: widget.dayIndex)).weekday;
                DateTime startEvent = start
                    .add(Duration(days: widget.dayIndex))
                    .copyWith(
                        hour: widget.minutesGrid == 0.5
                            ? widget.startHour + index ~/ 2
                            : widget.startHour + index,
                        minute: widget.minutesGrid == 0.5 && index % 2 != 0
                            ? 30
                            : 00);
                DateTime endEvent = end
                    .add(Duration(days: widget.dayIndex))
                    .copyWith(
                        hour: widget.minutesGrid == 0.5
                            ? widget.startHour + (index + 1) ~/ 2
                            : widget.startHour + (index + 1),
                        minute:
                            widget.minutesGrid == 0.5 && (index + 1) % 2 != 0
                                ? 30
                                : 00);
                return InkWell(
                  hoverColor: Colors.amber,
                  onTap: () {
                    widget.createLesson(
                      context: context,
                      initialStartTime: startEvent,
                      initialEndTime: endEvent,
                    );
                  },
                  child: widget.isLoading
                      ? SizedBox(
                          width: double.infinity,
                          height: widget.minutesGrid * 120,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.black,
                            child: Container(
                              width: double.infinity,
                              height: widget.minutesGrid * 120,
                              decoration: BoxDecoration(
                                  color: DateTime.now().millisecondsSinceEpoch >
                                          endEvent.millisecondsSinceEpoch
                                      ? const Color.fromARGB(10, 0, 0, 0)
                                      : null,
                                  border: Border.all(
                                      color: Colors.black12, width: 0.5)),
                            ),
                          ))
                      : Container(
                          width: double.infinity,
                          height: widget.minutesGrid * 120,
                          decoration: BoxDecoration(
                              //сб и вс
                              // color:  weekdayIndex == 6 || weekdayIndex == 7
                              //     ? const Color.fromARGB(20, 0, 0, 0)
                              //     : Colors.transparent,
                              //прошедшие дни
                              color: DateTime.now().millisecondsSinceEpoch >
                                      endEvent.millisecondsSinceEpoch
                                  ? const Color.fromARGB(10, 0, 0, 0)
                                  : null,
                              border: Border.all(
                                  color: Colors.black12, width: 0.5)),
                        ),
                );
              }),
            ),
          )),
          ...List.generate(widget.lessons.length, (index) {
            final lesson = widget.lessons[index];
            final start = lesson.start.hour * 60 + lesson.start.minute;
            final end = lesson.end.hour * 60 + lesson.end.minute;
            final top = (start - widget.startHour * 60.0) * 2;
            final height = (end - start).toDouble();
            return EventCardWidget(
                index: index,
                top: top,
                widget: widget,
                lesson: lesson,
                height: height);
          }),
          start.add(Duration(days: widget.dayIndex)).startOfDay() ==
                  DateTime.now().startOfDay()
              ? Positioned(
                  top: top - 2.5,
                  width: (widget.size / widget.viewDay) - 100 / widget.viewDay,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}


//========================Анимация=================================
// [ Positioned.fill(
//               child: SizedBox(
//             height: widget.minutesGrid * 120 * count,
//             child: AnimationLimiter(
//               child: Column(
//                 children: AnimationConfiguration.toStaggeredList(
//                   duration: const Duration(milliseconds: 200),
//                   childAnimationBuilder: (widget) => SlideAnimation(
//                     verticalOffset: 100,
//                     child: FadeInAnimation(
//                       child: widget,
//                     ),
//                   ),
//                   children: List.generate(count, (index) {
//                     // int weekdayIndex =
//                     //     start.add(Duration(days: widget.dayIndex)).weekday;
//                     DateTime startEvent = start
//                         .add(Duration(days: widget.dayIndex))
//                         .copyWith(
//                             hour: widget.minutesGrid == 0.5
//                                 ? widget.startHour + index ~/ 2
//                                 : widget.startHour + index,
//                             minute: widget.minutesGrid == 0.5 && index % 2 != 0
//                                 ? 30
//                                 : 00);
//                     DateTime endEvent = end
//                         .add(Duration(days: widget.dayIndex))
//                         .copyWith(
//                             hour: widget.minutesGrid == 0.5
//                                 ? widget.startHour + (index + 1) ~/ 2
//                                 : widget.startHour + (index + 1),
//                             minute: widget.minutesGrid == 0.5 &&
//                                     (index + 1) % 2 != 0
//                                 ? 30
//                                 : 00);
//                     return InkWell(
//                       hoverColor: Colors.amber,
//                       onTap: () {
//                         widget.createLesson(
//                           context,
//                           startEvent,
//                           endEvent,
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: widget.minutesGrid * 120,
//                         decoration: BoxDecoration(
//                             //сб и вс
//                             // color:  weekdayIndex == 6 || weekdayIndex == 7
//                             //     ? const Color.fromARGB(20, 0, 0, 0)
//                             //     : Colors.transparent,
//                             //прошедшие дни
//                             color: DateTime.now().millisecondsSinceEpoch >
//                                     endEvent.millisecondsSinceEpoch
//                                 ? const Color.fromARGB(10, 0, 0, 0)
//                                 : null,
//                             border:
//                                 Border.all(color: Colors.black12, width: 0.5)),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           )),
//           start.add(Duration(days: widget.dayIndex)).startOfDay() ==
//                   DateTime.now().startOfDay()
//               ? Positioned(
//                   top: ((DateTime.now().hour - widget.startHour) *
//                           2 *
//                           widget.minutesGrid *
//                           (widget.minutesGrid == 1 ? 60 : 120)) +
//                       DateTime.now().minute,
//                   width: (widget.size / widget.viewDay) - 100 / widget.viewDay,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 1,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Container(
//                         height: 5,
//                         width: 10,
//                         decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(2)),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//           ...List.generate(widget.lessons.length, (index) {
//             final lesson = widget.lessons[index];
//             final start = lesson.start.hour * 60 + lesson.start.minute;
//             final end = lesson.end.hour * 60 + lesson.end.minute;
//             final top = (start - widget.startHour * 60.0) * 2;
//             final height = (end - start).toDouble();
//             return EventCardWidget(
//                 index: index,
//                 top: top,
//                 widget: widget,
//                 lesson: lesson,
//                 height: height);
//           }),
//         ],
