import 'package:flutter/material.dart';

class CalendarTimeSection extends StatelessWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final bool mobile;

  const CalendarTimeSection({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.minutesGrid,
    required this.mobile,
  });

  List<String> generateTimeIntervals(
      int startHour, int endHour, double minutesGrid) {
    int totalMinutesGrid = (minutesGrid * 60).toInt();
    int totalMinutes = (endHour - startHour + 1) * 60;

    return List.generate(totalMinutes ~/ totalMinutesGrid, (index) {
      int minutes = index * totalMinutesGrid;
      int hours = startHour + minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeIntervals =
        generateTimeIntervals(startHour, endHour, minutesGrid);

    return SingleChildScrollView(
      child: Column(
        children: List.generate(timeIntervals.length - 1, (index) {
          return SizedBox(
            height: minutesGrid * 120,
            child: Text(
              timeIntervals[index],
              style: TextStyle(fontSize: mobile ? 12 : 16),
            ),
          );
        }),
      ),
    );
  }
}
