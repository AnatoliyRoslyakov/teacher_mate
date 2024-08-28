import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class TosterContent extends StatelessWidget {
  const TosterContent({
    super.key,
    required this.icon,
    required this.label,
  });
  final SvgPicture icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.mainColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: FittedBox(
                fit: BoxFit.cover,
                child: icon,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              label,
              style: AppTextStyle.b3f12.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
}
