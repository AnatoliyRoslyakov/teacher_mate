import 'package:calendar/calendar.dart';
import 'package:calendar/src/calendar_grid_section.dart';
import 'package:calendar/src/calendar_text_style.dart';
import 'package:flutter/material.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
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
          hoverColor: widget.lessons[index].type >= 0
              ? ColorType.values[widget.lessons[index].type].color
              : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            widget.createLesson(
                context: context,
                initialStartTime: lesson.start,
                initialEndTime: lesson.end,
                edit: true,
                description: lesson.description,
                selectedType: lesson.type,
                studentId: lesson.studentId,
                lessonId: lesson.id);
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
                    color: widget.lessons[index].type >= 0
                        ? ColorType.values[widget.lessons[index].type].color
                        : Colors.grey,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: height * 2,
                  width: (widget.size / widget.viewDay) - 100 / widget.viewDay,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                    color: widget.lessons[index].type >= 0
                        ? ColorType.values[widget.lessons[index].type].color
                            .withOpacity(0.6)
                        : Colors.grey.withOpacity(0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          maxLines: 2,
                          style: CalendarTextStyle.b5,
                          widget.student
                              .firstWhere(
                                (e) => e.id == lesson.studentId,
                                orElse: () => StudentEntity(
                                    id: 0, name: 'unknown', price: 0),
                              )
                              .name,
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            style: CalendarTextStyle.b3,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            '${lesson.start.hour}:${lesson.start.minute < 10 ? '0${lesson.start.minute}' : lesson.start.minute}\n${lesson.end.hour}:${lesson.end.minute < 10 ? '0${lesson.end.minute}' : lesson.end.minute}',
                          ),
                        ),
                      ),
                    ],
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
