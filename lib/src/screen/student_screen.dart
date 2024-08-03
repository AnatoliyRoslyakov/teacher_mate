import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/mobile/modal_bottom_sheet_wrapper.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ModalBottomSheetScaffoldWrapper(
        title: 'My students list',
        child: Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 40),
          child: StudentListWidget(
            mobile: true,
          ),
        ));
  }
}
