import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';
import 'package:teacher_mate/src/widgets/shared/create_student_widget.dart';

void createStudentDialog(
    {required BuildContext context,
    int id = 0,
    String name = '',
    bool edit = false,
    int price = 0,
    bool nested = false,
    String tgName = ''}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: nested ? 0 : 10.0, sigmaY: nested ? 0 : 10.0),
            child: Dialog(
                backgroundColor: Colors.white.withOpacity(nested ? 1 : 0.8),
                insetAnimationCurve: Curves.easeInCubic,
                insetAnimationDuration: const Duration(milliseconds: 500),
                child: SizedBox(
                    width: 600,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          edit ? 'Edit student' : 'Create student',
                          style: AppTextStyle.b5f18,
                        ),
                      ),
                      Expanded(
                        child: CreateStudentWidget(
                          id: id,
                          name: name,
                          edit: edit,
                          price: price,
                          tgName: tgName,
                        ),
                      ),
                    ]))),
          ));
    },
  );
}
