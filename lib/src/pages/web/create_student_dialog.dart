import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/shared/create_student_widget.dart';

void createStudentDialog({
  required BuildContext context,
  int id = 0,
  String name = '',
  bool edit = false,
  int price = 0,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
          insetAnimationCurve: Curves.linear,
          insetAnimationDuration: const Duration(milliseconds: 500),
          backgroundColor: Colors.white,
          child: SizedBox(
              width: 600,
              child: CreateStudentWidget(
                  id: id, name: name, edit: edit, price: price)));
    },
  );
}
