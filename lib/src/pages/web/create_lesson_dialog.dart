import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/shared/create_lesson_widget.dart';

void createLessonDialog(
    {required BuildContext context,
    required DateTime initialStartTime,
    required DateTime initialEndTime,
    bool edit = false,
    String description = '',
    int selectedType = 0,
    int studentId = -1,
    int lessonId = -1}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 600,
          child: CreateLessonWidget(
              // добавить заголовок
              initialStartTime: initialStartTime,
              initialEndTime: initialEndTime,
              edit: edit,
              description: description,
              selectedType: selectedType,
              studentId: studentId,
              lessonId: lessonId),
        ),
      );
    },
  );
}
