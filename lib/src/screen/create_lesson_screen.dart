import 'package:flutter/material.dart';
import 'package:teacher_mate/src/pages/mobile/create_lesson_page.dart';
import 'package:teacher_mate/src/widgets/mobile/wrapper/modal_bottom_sheet_wrapper.dart';

class CreateLessonScreen extends StatelessWidget {
  final DateTime initialStartTime;
  final DateTime initialEndTime;
  final bool edit;
  final String description;
  final int selectedType;
  final int studentId;
  final int lessonId;
  const CreateLessonScreen(
      {super.key,
      required this.initialStartTime,
      required this.initialEndTime,
      required this.edit,
      required this.description,
      required this.selectedType,
      required this.studentId,
      required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetScaffoldWrapper(
        title: edit ? 'Edit lesson' : 'Create lesson',
        child: CreateLessonPage(
          initialStartTime: initialStartTime,
          initialEndTime: initialEndTime,
          edit: edit,
          description: description,
          selectedType: selectedType,
          studentId: studentId,
          lessonId: lessonId,
        ));
  }
}
