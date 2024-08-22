import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class DividerTitleWidget extends StatelessWidget {
  final String title;
  final double height;
  const DividerTitleWidget({
    super.key,
    required this.title,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          title,
          style: AppTextStyle.b4f12,
        ),
        SizedBox(
          height: height,
        ),
      ],
    );
  }
}
