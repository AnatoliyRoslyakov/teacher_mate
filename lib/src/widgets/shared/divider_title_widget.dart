import 'package:flutter/material.dart';

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
        ),
        SizedBox(
          height: height,
        ),
      ],
    );
  }
}
