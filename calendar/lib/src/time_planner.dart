import 'dart:ui';

import 'package:calendar/calendar_page.dart';
import 'package:calendar/src/logic/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/config/global_config.dart' as config;
import 'package:calendar/src/time_planner_style.dart';
import 'package:calendar/src/time_planner_task.dart';
import 'package:calendar/src/time_planner_time.dart';
import 'package:calendar/src/time_planner_title.dart';
import 'package:intl/intl.dart';

/// Time planner widget
class TimePlanner extends StatefulWidget {
  /// Time start from this, it will start from 0
  final int startHour;

  /// Time end at this hour, max value is 23
  final int endHour;

  /// Create days from here, each day is a TimePlannerTitle.
  ///
  /// you should create at least one day
  final List<TimePlannerTitle> headers;

  /// List of widgets on time planner
  final List<CalendarTask>? tasks;

  /// Style of time planner
  final TimePlannerStyle? style;

  /// When widget loaded scroll to current time with an animation. Default is true
  final bool? currentTimeAnimation;

  /// Whether time is displayed in 24 hour format or am/pm format in the time column on the left.
  final bool use24HourFormat;

  //Whether the time is displayed on the axis of the tim or on the center of the timeblock. Default is false.
  final bool setTimeOnAxis;

  /// Time planner widget
  const TimePlanner({
    Key? key,
    required this.startHour,
    required this.endHour,
    required this.headers,
    this.tasks,
    this.style,
    this.use24HourFormat = false,
    this.setTimeOnAxis = false,
    this.currentTimeAnimation,
  }) : super(key: key);
  @override
  _TimePlannerState createState() => _TimePlannerState();
}

class _TimePlannerState extends State<TimePlanner> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  List<CalendarTask> tasks = [];
  bool? isAnimated = true;

  /// check input value rules
  void _checkInputValue() {
    if (widget.startHour > widget.endHour) {
      throw FlutterError("Start hour should be lower than end hour");
    } else if (widget.startHour < 0) {
      throw FlutterError("Start hour should be larger than 0");
    } else if (widget.endHour > 23) {
      throw FlutterError("Start hour should be lower than 23");
    } else if (widget.headers.isEmpty) {
      throw FlutterError("header can't be empty");
    }
  }

  /// create local style
  void _convertToLocalStyle() {
    style.backgroundColor = widget.style?.backgroundColor;
    style.cellHeight = widget.style?.cellHeight ?? 80;
    style.cellWidth = widget.style?.cellWidth ?? 90;
    style.horizontalTaskPadding = widget.style?.horizontalTaskPadding ?? 0;
    style.borderRadius = widget.style?.borderRadius ??
        const BorderRadius.all(Radius.circular(8.0));
    style.dividerColor = widget.style?.dividerColor;
    style.showScrollBar = widget.style?.showScrollBar ?? false;
    style.interstitialOddColor = widget.style?.interstitialOddColor;
    style.interstitialEvenColor = widget.style?.interstitialEvenColor;
  }

  /// store input data to static values
  void _initData() {
    _checkInputValue();
    _convertToLocalStyle();
    config.horizontalTaskPadding = style.horizontalTaskPadding;
    config.cellHeight = style.cellHeight;
    config.cellWidth = style.cellWidth;
    config.totalHours = (widget.endHour - widget.startHour).toDouble();
    config.totalDays = widget.headers.length;
    config.startHour = widget.startHour;
    config.use24HourFormat = widget.use24HourFormat;
    config.setTimeOnAxis = widget.setTimeOnAxis;
    config.borderRadius = style.borderRadius;
    isAnimated = widget.currentTimeAnimation;
    tasks = widget.tasks ?? [];
  }

  DateTime currentTime = DateTime.now();
  @override
  void initState() {
    _initData();
    super.initState();
    DateTime currentTime = DateTime.now();
    Future.delayed(Duration.zero).then((_) {
      int hour = DateTime.now().hour;
      if (isAnimated != null && isAnimated == true) {
        if (hour > widget.startHour) {
          double scrollOffset =
              (hour - widget.startHour) * config.cellHeight!.toDouble();
          mainVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
          timeVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
        }
      }
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tasks = widget.tasks ?? [];
    mainHorizontalController.addListener(() {
      dayHorizontalController.jumpTo(mainHorizontalController.offset);
    });
    mainVerticalController.addListener(() {
      timeVerticalController.jumpTo(mainVerticalController.offset);
    });
    return Container(
      color: style.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            controller: dayHorizontalController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  width: 60,
                ),
                for (int i = 0; i < config.totalDays; i++) widget.headers[i],
              ],
            ),
          ),
          // Container(
          //   height: 1,
          //   color: style.dividerColor ?? Theme.of(context).primaryColor,
          // ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: timeVerticalController,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //first number is start hour and second number is end hour
                            for (int i = widget.startHour;
                                i <= widget.endHour;
                                i++)
                              Padding(
                                // we need some additional padding horizontally if we're showing in am/pm format
                                padding: EdgeInsets.symmetric(
                                  horizontal: !config.use24HourFormat ? 4 : 0,
                                ),
                                child: TimePlannerTime(
                                  time: formattedTime(i),
                                  setTimeOnAxis: config.setTimeOnAxis,
                                ),
                              )
                          ],
                        ),
                        // Container(
                        //   height: (config.totalHours * config.cellHeight!) + 80,
                        //   width: 1,
                        //   color: style.dividerColor ??
                        //       Theme.of(context).primaryColor,
                        // ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: buildMainBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBlurredDialog(BuildContext context, TimeOfDay initialStartTime) {
    final TextEditingController textController = TextEditingController();
    TimeOfDay startTime = initialStartTime;
    TimeOfDay endTime = initialStartTime;
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
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width - 100,
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
                        Text('Диалоговое окно', style: TextStyle(fontSize: 24)),
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
                              initialTime: startTime,
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
                            if (picked != null && picked != startTime) {
                              setState(() {
                                startTime = picked;
                                selectedTime =
                                    'Начальное время: ${_formatTimeOfDay(startTime)}';
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
                              initialTime: endTime,
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
                            if (picked != null && picked != endTime) {
                              setState(() {
                                endTime = picked;
                                selectedTime +=
                                    ', Время окончания: ${_formatTimeOfDay(endTime)}';
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

  String _formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String formattedHour = hour.toString().padLeft(2, '0');
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }

  Widget buildMainBody() {
    final titles = ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final startTime = currentTime.startOfCurrentWeek();
    return Scaffold(
      backgroundColor: const Color(0xffcfd7e5),
      body: Column(
        children: [
          Row(
            children: List.generate(8, (index) {
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
                    8,
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

  // return SingleChildScrollView(
  //   controller: mainVerticalController,
  //   child: SingleChildScrollView(
  //       controller: mainHorizontalController,
  //       scrollDirection: Axis.horizontal,
  //       child: Align(
  //         alignment: Alignment.topLeft,
  //         child: Container(
  //           height: (config.totalHours * config.cellHeight!) + 80,
  //           width: (config.totalDays * config.cellWidth!).toDouble(),
  //           color: Colors.grey[100],
  //           child: Stack(
  //             children: [
  //               GridView.builder(
  //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: config.totalDays,
  //                   childAspectRatio: config.cellWidth! / config.cellHeight!,
  //                 ),
  //                 itemCount:
  //                     (config.totalHours.toInt() + 1) * config.totalDays,
  //                 itemBuilder: (context, index) {
  //                   int day = index % config.totalDays + 1;

  //                   return InkWell(
  //                     onTap: () {
  //                       _showBlurredDialog(
  //                           context, TimeOfDay(hour: 10, minute: 20));
  //                     },
  //                     child: Container(
  //                       margin: EdgeInsets.all(1),
  //                       color: Colors.white,
  //                       child: Center(
  //                         child: Text('$day'),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //               // Добавляем задачи на календарь
  //               ...tasks.where((task) {
  //                 DateTime taskDate = DateTime(
  //                   task.dateTime.year,
  //                   task.dateTime.month,
  //                   task.dateTime.day,
  //                 );
  //                 return taskDate.year == 2024 && taskDate.month == 5;
  //               }).map((task) {
  //                 double top = ((config.cellHeight! *
  //                             (task.dateTime.hour - config.startHour)) +
  //                         ((task.dateTime.minutes * config.cellHeight!) / 60))
  //                     .toDouble();
  //                 double left =
  //                     config.cellWidth! * (task.dateTime.day - 1).toDouble();

  //                 return Positioned(
  //                   top: top,
  //                   left: left,
  //                   child: TimePlannerTask(
  //                     task: task,
  //                     widthTask: config.cellWidth!.toDouble(),
  //                     leftSpace: 0.0,
  //                     onTap: () {
  //                       // Обработка нажатия на задачу
  //                     },
  //                   ),
  //                 );
  //               }).toList(),
  //             ],
  //           ),
  //         ),
  //       )),
  // );

  //   return SingleChildScrollView(
  //     controller: mainVerticalController,
  //     child: SingleChildScrollView(
  //       controller: mainHorizontalController,
  //       scrollDirection: Axis.horizontal,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               InkWell(
  //                 onTap: () {},
  //                 overlayColor: MaterialStateProperty.all(Colors.green),
  //                 child: SizedBox(
  //                   height: (config.totalHours * config.cellHeight!) + 80,
  //                   width: (config.totalDays * config.cellWidth!).toDouble(),
  //                   child: Stack(
  //                     children: <Widget>[
  //                       Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           for (var i = 0; i < config.totalHours; i++)
  //                             Column(
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: <Widget>[
  //                                 SizedBox(
  //                                   height: (config.cellHeight! - 1).toDouble(),
  //                                 ),
  //                                 const Divider(
  //                                   height: 1,
  //                                 ),
  //                               ],
  //                             )
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           for (var i = 0; i < config.totalDays; i++)
  //                             Row(
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: <Widget>[
  //                                 SizedBox(
  //                                   width: (config.cellWidth! - 1).toDouble(),
  //                                 ),
  //                                 Container(
  //                                   width: 1,
  //                                   height: (config.totalHours *
  //                                           config.cellHeight!) +
  //                                       config.cellHeight!,
  //                                   color: Colors.black12,
  //                                 )
  //                               ],
  //                             )
  //                         ],
  //                       ),
  //                       for (int i = 0; i < tasks.length; i++) tasks[i],
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String formattedTime(int hour) {
    /// this method formats the input hour into a time string
    /// modifing it as necessary based on the use24HourFormat flag .
    if (config.use24HourFormat) {
      // we use the hour as-is
      return hour.toString() + ':00';
    } else {
      // we format the time to use the am/pm scheme
      if (hour == 0) return "12:00 am";
      if (hour < 12) return "$hour:00 am";
      if (hour == 12) return "12:00 pm";
      return "${hour - 12}:00 pm";
    }
  }
}
