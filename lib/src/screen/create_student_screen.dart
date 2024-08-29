import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/mobile/modal_bottom_sheet_wrapper.dart';
import 'package:teacher_mate/src/widgets/shared/create_student_widget.dart';

class CreateStudentScreen extends StatelessWidget {
  final int id;
  final String name;
  final bool edit;
  final int price;
  final String? tgName;
  const CreateStudentScreen({
    super.key,
    required this.id,
    required this.name,
    required this.edit,
    required this.price,
    required this.tgName,
  });

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetScaffoldWrapper(
        title: edit ? 'Edit student' : 'Add student',
        child: CreateStudentWidget(
            id: id,
            name: name,
            edit: edit,
            price: price,
            tgName: tgName.toString()));
  }
}
