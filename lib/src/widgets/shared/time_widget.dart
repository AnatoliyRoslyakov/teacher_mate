import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
    required this.selectedTimeEnd,
    required this.isValid,
    required this.helperText,
  });

  final String selectedTimeEnd;
  final bool isValid;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          helperText,
          style: AppTextStyle.b3f10,
        ),
        Text(
          selectedTimeEnd,
          style: AppTextStyle.b7f32
              .copyWith(color: isValid ? Colors.black87 : Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
