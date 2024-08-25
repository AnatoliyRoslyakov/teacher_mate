import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color? iconColor;
  final void Function()? onTap;
  final ButtonStyle buttonStyle;

  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.buttonStyle,
    this.iconColor = AppColors.mainColor,
  });

  factory AppButton.settings({
    required String label,
    required Widget icon,
    required void Function()? onTap,
    bool mobile = true,
    Color backgroundColor = Colors.white,
    Color iconColor = AppColors.mainColor,
  }) {
    return AppButton(
      label: label,
      icon: icon,
      onTap: onTap,
      iconColor: iconColor,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.zero,
        minimumSize: Size(double.infinity, mobile ? 50 : 70),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  factory AppButton.base({
    required String label,
    required void Function()? onTap,
  }) {
    return AppButton(
      label: label,
      icon: null,
      onTap: onTap,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: onTap == null ? Colors.white : AppColors.mainColor,
        padding: EdgeInsets.zero,
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  factory AppButton.icon({
    required Widget icon,
    required void Function()? onTap,
    Color iconColor = AppColors.mainColor,
    Color backgroundColor = Colors.white,
  }) {
    return AppButton(
      label: '',
      icon: icon,
      onTap: onTap,
      iconColor: iconColor,
      buttonStyle: ElevatedButton.styleFrom(
        overlayColor: AppColors.mainColor,
        shadowColor: Colors.transparent,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      iconAlignment: IconAlignment.start,
      onPressed: onTap,
      style: buttonStyle,
      child: icon == null
          ? Text(
              label,
              style: AppTextStyle.b5f15.copyWith(color: Colors.white),
            )
          : label.isEmpty
              ? SizedBox(height: 25, width: 25, child: icon)
              : Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 242, 242),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(7.5),
                          child: SizedBox(height: 20, width: 20, child: icon)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      label,
                      style: AppTextStyle.b4f15,
                    ),
                  ],
                ),
    );
  }
}
