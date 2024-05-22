import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime currentTime;

  final dio = Dio();

  @override
  void initState() {
    currentTime = DateTime.now();
    // getLessons();
    super.initState();
  }

  void prevWeek() {
    setState(() {
      currentTime = currentTime.subtract(const Duration(days: 7));
    });
  }

  void nextWeek() {
    setState(() {
      currentTime = currentTime.add(const Duration(days: 7));
    });
  }

  List<List<Lesson>> get lessonsData {
    final startTime = currentTime.startOfCurrentWeek().startOfDay();
    final result = <List<Lesson>>[[]];
    for (int i = 0; i < 7; i++) {
      result.add(lessons[startTime.add(Duration(days: i))] ?? []);
    }
    return result;
  }

  // Future<void> addLesson() async {}

  // Future<void> getLessons() async {
  //   const url = 'http://localhost:8080/lessons/getAllLessons';
  //   final response = await dio.get(url);
  //   final list = (response.data as List)
  //       .map(
  //         (e) => Lesson(
  //           start: DateTime.fromMillisecondsSinceEpoch(e['start'] * 1000),
  //           end: DateTime.fromMillisecondsSinceEpoch(e['end'] * 1000),
  //           name: e['name'],
  //         ),
  //       )
  //       .toList();

  //   setState(() {
  //     lessons = _getItemsGroup(list);
  //     print(lessons);
  //   });
  // }

  Map<DateTime, List<Lesson>> _getItemsGroup(
    List<Lesson> data,
  ) {
    final result = <DateTime, List<Lesson>>{};

    for (final item in data) {
      final DateTime time = item.start.startOfDay();
      if (result[time] != null) {
        result[time]?.add(item);
      } else {
        result[time] = <Lesson>[item];
      }
    }

    final List<MapEntry<DateTime, List<Lesson>>> entries =
        result.entries.toList();

    entries.sort((b, a) => a.key.compareTo(b.key));

    final Map<DateTime, List<Lesson>> sortedMap = Map.fromEntries(
      entries.map((entry) {
        final value = entry.value;
        value.sort((b, a) => a.start.compareTo(b.start));
        return MapEntry(entry.key, entry.value);
      }),
    );

    return sortedMap;
  }

  Map<DateTime, List<Lesson>> lessons = {
    DateTime(2024, 5, 20): [
      Lesson(
          start: DateTime(2024, 5, 20, 14, 00),
          end: DateTime(2024, 5, 20, 15, 00),
          name: 'Евгений'),
      Lesson(
          start: DateTime(2024, 5, 20, 15, 00),
          end: DateTime(2024, 5, 20, 15, 30),
          name: 'Алеся'),
      Lesson(
          start: DateTime(2024, 5, 20, 15, 30),
          end: DateTime(2024, 5, 20, 16, 00),
          name: 'Василий')
    ],
    DateTime(2024, 5, 21): [
      Lesson(
          start: DateTime(2024, 5, 21, 14, 00),
          end: DateTime(2024, 5, 21, 15, 00),
          name: 'Елена (США)'),
      Lesson(
          start: DateTime(2024, 5, 21, 15, 00),
          end: DateTime(2024, 5, 21, 15, 30),
          name: 'Таня'),
      Lesson(
          start: DateTime(2024, 5, 21, 15, 30),
          end: DateTime(2024, 5, 21, 16, 00),
          name: 'Пробный с к'),
      Lesson(
          start: DateTime(2024, 5, 21, 16, 00),
          end: DateTime(2024, 5, 21, 16, 30),
          name: 'Василий')
    ],
    DateTime(2024, 5, 22): [
      Lesson(
          start: DateTime(2024, 5, 21, 15, 00),
          end: DateTime(2024, 5, 21, 15, 30),
          name: 'Sprint Calendar')
    ],
  };

  @override
  Widget build(BuildContext context) {
    final titles = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final startTime = currentTime.startOfCurrentWeek();
    return Scaffold(
      backgroundColor: const Color(0xffcfd7e5),
      body: Column(
        children: [
          Row(
            children: List.generate(7, (index) {
              if (index == 0) {
                return SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          prevWeek();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: () {
                          nextWeek();
                        },
                        icon: const Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                );
              }
              final time = DateFormat('dd.MM')
                  .format(startTime.add(Duration(days: index - 1)));
              return Expanded(
                  child: Center(
                child: Text(
                  '${titles[index]} $time',
                ),
              ));
            }),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: List.generate(
                    7,
                    (index) => index == 0
                        ? const ColumnTimeWidget()
                        : Expanded(
                            child: ColumnDayWidget(
                            lessons: lessonsData[index],
                          ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnTimeWidget extends StatelessWidget {
  const ColumnTimeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const minutesGrid = 0.5;
    final start = DateTime.now().copyWith(hour: 9, minute: 0);
    final end = DateTime.now().copyWith(hour: 22, minute: 0);
    final count = (end.hour - start.hour) ~/ minutesGrid;
    return SizedBox(
      height: count * 60,
      width: 100,
      child: Column(
        children: List.generate(count, (index) {
          final hour = (index + 18) ~/ 2;
          final minutes =
              int.parse(((index + 18) / 2).toString().split('.').last) * 6;
          return Container(
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Text(
                '$hour:${minutes.toString().length < 2 ? '0$minutes' : minutes}'),
          );
        }),
      ),
    );
  }
}

class ColumnDayWidget extends StatelessWidget {
  final List<Lesson> lessons;
  const ColumnDayWidget({
    super.key,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    const minutesGrid = 0.5;
    final start = DateTime.now().copyWith(hour: 9, minute: 0);
    final end = DateTime.now().copyWith(hour: 22, minute: 0);
    final count = (end.hour - start.hour) ~/ minutesGrid;
    return SizedBox(
      height: count * 60,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: SizedBox(
              height: 60.0 * count,
              child: Column(
                children: List.generate(count, (index) {
                  return GestureDetector(
                    onTap: () {
                      print('onTap $index');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                    ),
                  );
                }),
              ),
            ),
          ),
          ...List.generate(lessons.length, (index) {
            final lesson = lessons[index];
            final start = lesson.start.hour * 60 + lesson.start.minute;
            final end = lesson.end.hour * 60 + lesson.end.minute;
            final top = (start - 9 * 60.0) * 2;
            final height = (end - start).toDouble();
            return Positioned(
                top: top,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      print(lesson.name);
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 7) - 100 / 7,
                      height: height * 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: [
                            Text(
                                '${lesson.start.hour}:${lesson.start.minute}-${lesson.end.hour}:${lesson.end.minute}'),
                            Text(
                              lesson.name,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }),
        ],
      ),
    );
  }
}

class Lesson {
  final DateTime start;
  final DateTime end;
  final String name;

  Lesson({required this.start, required this.end, required this.name});
}

extension DateTimeExt on DateTime {
  DateTime get monthStart {
    return DateTime(year, month);
  }

  DateTime nextMonth() {
    if (month == DateTime.december) {
      return DateTime(year + 1);
    }
    return DateTime(year, month + 1);
  }

  DateTime prevMonth() {
    if (month == DateTime.january) {
      return DateTime(year - 1, DateTime.december);
    }
    return DateTime(year, month - 1);
  }

  DateTime startOfCurrentWeek() {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime lastDayOfWeek() {
    return add(Duration(days: 7 - weekday));
  }

  DateTime endOfCurrentMonth() {
    return nextMonth().subtract(const Duration(microseconds: 1)).startOfDay();
  }

  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
