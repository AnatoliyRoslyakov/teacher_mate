import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';
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
      return ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Dialog(
              insetAnimationCurve: Curves.ease,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: SizedBox(
                width: 600,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        edit ? 'Edit lesson' : 'Create lesson',
                        style: AppTextStyle.b5f18,
                      ),
                    ),
                    Expanded(
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
                  ],
                ),
              ),
            ),
          ));
    },
  );
}
