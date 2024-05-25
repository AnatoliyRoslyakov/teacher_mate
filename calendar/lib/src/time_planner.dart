import 'package:calendar/calendar_page.dart';
import 'package:calendar/main.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/time_planner_style.dart';
import 'package:calendar/src/time_planner_time.dart';
import 'package:intl/intl.dart';

class TimePlanner extends StatefulWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final Map<DateTime, List<Lesson>>? lessons;

  final TimePlannerStyle? style;

  const TimePlanner({
    super.key,
    required this.startHour,
    required this.endHour,
    this.lessons,
    this.style,
    required this.minutesGrid,
  });
  @override
  _TimePlannerState createState() => _TimePlannerState();
}

class _TimePlannerState extends State<TimePlanner> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  bool? isAnimated = true;

  DateTime currentTime = DateTime.now();

  void currentWeek() {
    setState(() {
      currentTime = DateTime.now();
    });
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
      result.add(widget.lessons?[startTime.add(Duration(days: i))] ?? []);
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startTime = currentTime.startOfCurrentWeek();
    return Column(
      children: [
        DateRangeWidget(
          nextDate: () {
            nextWeek();
          },
          afterDate: () {
            prevWeek();
          },
        ),
        // const SizedBox(
        //   height: 40,
        // ),
        Row(children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: IconButton(
                  onPressed: () {
                    currentWeek();
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                  )),
            ),
          ),
          ...List.generate(7, (index) {
            final time = DateFormat('E dd.MM')
                .format(startTime.add(Duration(days: index)));
            return Expanded(
                child: Center(
              child: Text(
                time,
              ),
            ));
          }),
        ]),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TimeIntervalsWidget(
                            startHour: widget.startHour,
                            endHour: widget.endHour,
                            minutesGrid: widget.minutesGrid),
                      ),
                      ...List.generate(
                          7,
                          (index) => Expanded(
                                  child: ColumnDayWidget(
                                lessons: lessonsData[index + 1],
                                startHour: widget.startHour,
                                endHour: widget.endHour,
                                minutesGrid: widget.minutesGrid,
                              ))),
                    ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void showBlurredDialog(
  BuildContext context,
  DateTime initialStartTime,
  DateTime initialEndTime,
) {
  final TextEditingController textController = TextEditingController();

  String selectedTime = '';

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Создать урок', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Введите текст',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: initialStartTime.hour,
                                minute: initialStartTime.minute),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime =
                                  'Начальное время: ${DateFormat('E dd.MM').format(initialStartTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                            });
                          }
                        },
                        child: Text('Выберите начальное время'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: initialEndTime.hour,
                                minute: initialEndTime.minute),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTime +=
                                  ', Время окончания: ${DateFormat('E dd.MM').format(initialEndTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                            });
                          }
                        },
                        child: Text('Выберите время окончания'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        selectedTime,
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Закрыть'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
