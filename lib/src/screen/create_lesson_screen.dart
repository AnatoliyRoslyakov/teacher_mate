import 'package:flutter/material.dart';
import 'package:teacher_mate/src/pages/mobile/create_lesson_page.dart';
import 'package:teacher_mate/src/widgets/mobile/wrapper/modal_bottom_sheet_wrapper.dart';

class CreateLessonScreen extends StatelessWidget {
  const CreateLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModalBottomSheetScaffoldWrapper(
        title: 'Detail screen', child: CreateLessonPage());
  }
}
