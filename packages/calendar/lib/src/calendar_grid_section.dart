import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  final double size;
  final bool mobile;
  final void Function({required String id}) deleteLesson;
  final void Function(
    BuildContext context,
    DateTime initialStartTime,
    DateTime initialEndTime,
  ) createLesson;

  const CalendarGridSection({
    super.key,
    required this.lessons,
    required this.startHour,
    required this.endHour,
    required this.minutesGrid,
    required this.dayIndex,
    required this.currentTime,
    required this.deleteLesson,
    required this.viewDay,
    required this.startOfWeek,
    required this.size,
    required this.student,
    required this.mobile,
    required this.createLesson,
  });

  @override
  State<CalendarGridSection> createState() => _CalendarGridSectionState();
}

class _CalendarGridSectionState extends State<CalendarGridSection> {
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
                    int weekdayIndex =
                        start.add(Duration(days: widget.dayIndex)).weekday;
                    return InkWell(
                      hoverColor: Colors.amber,
                      onTap: () {
                        widget.createLesson(
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
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: widget.minutesGrid * 120,
                        decoration: BoxDecoration(
                            color: weekdayIndex == 6 || weekdayIndex == 7
                                ? const Color.fromARGB(11, 0, 0, 0)
                                : Colors.transparent,
                            border:
                                Border.all(color: Colors.black12, width: 0.5)),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )),
          start.add(Duration(days: widget.dayIndex)).startOfDay() ==
                  DateTime.now().startOfDay()
              ? Positioned(
                  top: ((DateTime.now().hour - widget.startHour) *
                          2 *
                          widget.minutesGrid *
                          (widget.minutesGrid == 1 ? 60 : 120)) +
                      DateTime.now().minute,
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
          ...List.generate(widget.lessons.length, (index) {
            final lesson = widget.lessons[index];
            final start = lesson.start.hour * 60 + lesson.start.minute;
            final end = lesson.end.hour * 60 + lesson.end.minute;
            final top = (start - widget.startHour * 60.0) * 2;
            final height = (end - start).toDouble();
            return LessonCardWidget(
                index: index,
                top: top,
                widget: widget,
                lesson: lesson,
                height: height);
          }),
        ],
      ),
    );
  }
}

class LessonCardWidget extends StatelessWidget {
  const LessonCardWidget({
    Key? key,
    required this.top,
    required this.widget,
    required this.lesson,
    required this.height,
    required this.index,
  }) : super(key: key);

  final double top;
  final CalendarGridSection widget;
  final LessonEntity lesson;
  final double height;
  final int index;

//AnimatedPositioned  анимирует изменение ПОЛОЖЕНИЯ виджета,
//AnimatedContainer анимирует изменение РАЗМЕРА контейнеров внутри LessonCardWidget
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: top,
      child: Center(
        child: InkWell(
          hoverColor: ColorType.values[widget.lessons[index].type].color,
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            widget.deleteLesson(id: lesson.name);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: (widget.size / widget.viewDay) - 100 / widget.viewDay + 5,
            height: height * 2,
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                    ),
                    color: ColorType.values[widget.lessons[index].type].color,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: height * 2,
                  width:
                      (widget.size / widget.viewDay) - 100 / widget.viewDay - 2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                    color: ColorType.values[widget.lessons[index].type].color
                        .withOpacity(0.6),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Text(
                          widget.student
                              .firstWhere(
                                (e) => e.id == lesson.studentId,
                                orElse: () => StudentEntity(
                                    id: 0, name: 'unknown', price: 0),
                              )
                              .name,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          '${lesson.start.hour}:${lesson.start.minute < 10 ? '0${lesson.start.minute}' : lesson.start.minute}-${lesson.end.hour}:${lesson.end.minute}',
                          style: const TextStyle(fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
