part of 'calendar_bloc.dart';

class CalendarState {
  final DateTime startDate;
  final List<CalendarTask> tasks = const [];
  const CalendarState(
      {required this.startDate, required List<CalendarTask> tasks});
  factory CalendarState.initial() => CalendarState(
        startDate: DateTime.now(),
        tasks: const [],
      );
}

class CalendarTask {
  final int minutesDuration;
  final DateTaskStart dateTime;
  final Color color;
  final String title;

  CalendarTask({
    required this.minutesDuration,
    required this.dateTime,
    this.color = Colors.grey,
    required this.title,
  });
}

class DateTaskStart {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minutes;
  DateTaskStart({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minutes,
  });
}
