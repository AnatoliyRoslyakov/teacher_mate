import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final void Function()? onTap;
  final ButtonStyle buttonStyle;

  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.buttonStyle,
    this.iconColor = Colors.amber,
  });

  factory AppButton.settings({
    required String label,
    required IconData icon,
    required void Function()? onTap,
    bool mobile = true,
    Color backgroundColor = Colors.white,
    Color iconColor = Colors.amber,
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
        backgroundColor: onTap == null ? Colors.white : Colors.amber,
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
    required IconData icon,
    required void Function()? onTap,
    Color iconColor = Colors.amber,
  }) {
    return AppButton(
      label: '',
      icon: icon,
      onTap: onTap,
      iconColor: iconColor,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
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
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            )
          : label.isEmpty
              ? Icon(
                  icon,
                  size: 25,
                  color: iconColor,
                )
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
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          icon,
                          size: 20,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
    );
  }
}
