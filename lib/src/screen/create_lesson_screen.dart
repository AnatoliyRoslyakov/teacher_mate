import 'package:flutter/material.dart';
import 'package:teacher_mate/src/pages/mobile/create_lesson_page.dart';
import 'package:teacher_mate/src/widgets/mobile/wrapper/modal_bottom_sheet_wrapper.dart';

class CreateLessonScreen extends StatelessWidget {
  final DateTime initialStartTime;
  final DateTime initialEndTime;
  const CreateLessonScreen(
      {super.key,
      required this.initialStartTime,
      required this.initialEndTime});

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetScaffoldWrapper(
        title: 'Create a lesson',
        child: CreateLessonPage(
            initialStartTime: initialStartTime,
            initialEndTime: initialEndTime));
  }
}
