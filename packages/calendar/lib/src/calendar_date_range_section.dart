import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSection extends StatefulWidget {
  final VoidCallback nextDate;
  final VoidCallback afterDate;
  final int viewDay;
  final bool startOfWeek;

  const DateRangeSection(
      {super.key,
      required this.nextDate,
      required this.afterDate,
      required this.viewDay,
      required this.startOfWeek});
  @override
  _DateRangeSectionState createState() => _DateRangeSectionState();
}

class _DateRangeSectionState extends State<DateRangeSection> {
  DateTime _selectedDate = DateTime.now();
  int viewDay = 7;

  void _updateDate(bool isForward) {
    setState(() {
      _selectedDate = isForward
          ? _selectedDate.add(
              Duration(days: widget.startOfWeek ? viewDay : widget.viewDay))
          : _selectedDate.subtract(
              Duration(days: widget.startOfWeek ? viewDay : widget.viewDay));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.startOfWeek
        ? DateTime.now().startOfCurrentWeek()
        : _selectedDate;
    DateTime endDate = widget.startOfWeek
        ? DateTime.now().startOfCurrentWeek().add(Duration(days: viewDay - 1))
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
              '$formattedStartDate - $formattedEndDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
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
