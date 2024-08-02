import 'package:calendar/src/calendar_date_range_section.dart';
import 'package:calendar/src/calendar_days_section.dart';
import 'package:calendar/src/calendar_grid_section.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/calendar_time_section.dart';

class Calendar extends StatefulWidget {
  final int startHour;
  final int endHour;
  final double minutesGrid;
  final Map<DateTime, List<LessonEntity>> lessons;
  final List<StudentEntity> student;
  final int viewDay;
  final bool startOfWeek;
  final bool threeDays;
  final bool mobile;
  final void Function(
      {required BuildContext context,
      required DateTime initialStartTime,
      required DateTime initialEndTime,
      bool edit,
      String description,
      int selectedType,
      int studentId,
      int lessonId}) createLesson;

  const Calendar({
    this.mobile = false,
    super.key,
    required this.startHour,
    required this.endHour,
    required this.lessons,
    required this.minutesGrid,
    required this.viewDay,
    required this.startOfWeek,
    required this.student,
    required this.createLesson,
    required this.threeDays,
  });
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  late ScrollController scrollController;
  bool? isAnimated = true;

  DateTime currentTime = DateTime.now();

  PageController _pageController = PageController();
  int _currentPage = 10000;
  double width = 60;

  @override
  void initState() {
    super.initState();
    final double initPosition = (DateTime.now().hour - widget.startHour) *
            2 *
            widget.minutesGrid *
            (widget.minutesGrid == 1 ? 60 : 120) -
        60;
    scrollController = ScrollController(initialScrollOffset: initPosition);
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(_onPageChanged);
    width = widget.mobile ? 40 : 60;
  }

  @override
  void dispose() {
    _pageController.dispose();
    scrollController.dispose();
    timeVerticalController.dispose();
    dayHorizontalController.dispose();
    mainHorizontalController.dispose();
    mainVerticalController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    if (_pageController.page?.round() != _currentPage) {
      if ((_pageController.page?.round() ?? _currentPage) > _currentPage) {
        nextWeek();
      } else {
        prevWeek();
      }
      _currentPage = _pageController.page?.round() ?? _currentPage;
    }
  }

  void currentWeek() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  void prevWeek() {
    setState(() {
      currentTime = currentTime.subtract(Duration(days: widget.viewDay));
    });
  }

  void nextWeek() {
    setState(() {
      currentTime = currentTime.add(Duration(days: widget.viewDay));
    });
  }

  List<List<LessonEntity>> get lessonsData {
    final startTime = widget.startOfWeek
        ? currentTime.startOfCurrentWeek().startOfDay()
        : currentTime.startOfDay();
    final result = <List<LessonEntity>>[[]];
    for (int i = 0; i < (widget.viewDay); i++) {
      result.add(widget.lessons[startTime.add(Duration(days: i))] ?? []);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // из-за этого идет задержка, пока виджеты полностью построятся

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (DateTime.now().hour > 13) {
    //     scrollController.jumpTo(((DateTime.now().hour - widget.startHour) *
    //             2 *
    //             widget.minutesGrid *
    //             (widget.minutesGrid == 1 ? 60 : 120)) -
    //         60);
    //   }
    // });

    final startTime =
        widget.startOfWeek ? currentTime.startOfCurrentWeek() : currentTime;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 35,
              ),
              DateRangeSection(
                threeWeek: widget.threeDays,
                nextDate: nextWeek,
                afterDate: prevWeek,
                viewDay: widget.viewDay,
                startOfWeek: widget.startOfWeek,
                currentTime: currentTime,
                mobile: widget.mobile,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: GestureDetector(
                  onTap: () {
                    currentWeek();
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        DateTime.now().day.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: PageView.builder(
              physics: widget.mobile
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    children: [
                      CalendarDaysSection(
                          widget: widget,
                          viewDay: widget.viewDay,
                          startTime: startTime),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width,
                                  child: CalendarTimeSection(
                                      mobile: widget.mobile,
                                      startHour: widget.startHour,
                                      endHour: widget.endHour,
                                      minutesGrid: widget.minutesGrid),
                                ),
                                ...List.generate(
                                    widget.viewDay,
                                    (index) => Expanded(
                                            child: CalendarGridSection(
                                          createLesson: widget.createLesson,
                                          mobile: widget.mobile,
                                          student: widget.student,
                                          size: constraints.maxWidth,
                                          startOfWeek: widget.startOfWeek,
                                          threeDays: widget.threeDays,
                                          viewDay: widget.viewDay,
                                          currentTime: currentTime,
                                          dayIndex: index,
                                          lessons: lessonsData[index + 1],
                                          startHour: widget.startHour,
                                          endHour: widget.endHour,
                                          minutesGrid: widget.minutesGrid,
                                        ))),
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class LessonEntity {
  final DateTime start;
  final DateTime end;
  final String name;
  final int studentId;
  final int type;
  final int id;
  final String description;

  LessonEntity(
      {required this.description,
      required this.studentId,
      required this.type,
      required this.id,
      required this.start,
      required this.end,
      required this.name});
}

class StudentEntity {
  final int id;
  final String name;
  final int price;

  StudentEntity({
    required this.id,
    required this.name,
    required this.price,
  });
}

enum ColorType {
  blue(0, Colors.blue),
  red(1, Colors.red),
  green(2, Colors.green),
  yellow(3, Colors.yellow),
  purple(4, Colors.purple);

  final int value;
  final MaterialColor color;

  const ColorType(this.value, this.color);

  static ColorType? fromValue(int value) {
    return ColorType.values.firstWhere(
      (e) => e.value == value,
    );
  }

  MaterialColor getColor(int value) {
    return color;
  }
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
