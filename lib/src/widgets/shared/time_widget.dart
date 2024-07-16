import 'package:flutter/material.dart';

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
          style: const TextStyle(fontSize: 10),
        ),
        Text(
          selectedTimeEnd,
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: isValid ? Colors.black : Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
