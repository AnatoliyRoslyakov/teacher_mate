import 'package:calendar/calendar.dart';
import 'package:calendar/src/calendar_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSection extends StatefulWidget {
  final VoidCallback nextDate;
  final VoidCallback afterDate;
  final int viewDay;
  final bool startOfWeek;
  final bool threeWeek;
  final DateTime currentTime;
  final bool mobile;

  const DateRangeSection(
      {super.key,
      required this.nextDate,
      required this.afterDate,
      required this.viewDay,
      required this.startOfWeek,
      required this.currentTime,
      required this.mobile,
      required this.threeWeek});
  @override
  _DateRangeSectionState createState() => _DateRangeSectionState();
}

class _DateRangeSectionState extends State<DateRangeSection> {
  DateTime _selectedDate = DateTime.now();
  int viewDay = 7;

  @override
  void initState() {
    _selectedDate.subtract(Duration(days: widget.threeWeek ? 1 : 0));
    super.initState();
  }

  void _updateDate(bool isForward) {
    setState(() {
      _selectedDate = isForward
          ? widget.currentTime.add(Duration(days: widget.viewDay))
          : widget.currentTime.subtract(Duration(days: widget.viewDay));
    });
  }

  @override
  void didUpdateWidget(covariant DateRangeSection oldWidget) {
    if (oldWidget.currentTime != widget.currentTime) {
      setState(() {
        _selectedDate = widget.currentTime;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.startOfWeek
        ? widget.currentTime.startOfCurrentWeek()
        : _selectedDate;
    DateTime endDate = widget.startOfWeek
        ? widget.currentTime
            .startOfCurrentWeek()
            .add(Duration(days: viewDay - 1))
        : _selectedDate.add(Duration(days: widget.viewDay - 1));
    String formattedStartDate = DateFormat('dd MMM').format(startDate);
    String formattedEndDate = DateFormat('dd MMM').format(endDate);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.afterDate.call();
                _updateDate(false);
              },
            ),
            Text(
              '$formattedStartDate — $formattedEndDate',
              style: CalendarTextStyle.b3f16,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                widget.nextDate.call();
                _updateDate(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
