import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSection extends StatefulWidget {
  final VoidCallback nextDate;
  final VoidCallback afterDate;

  const DateRangeSection(
      {super.key, required this.nextDate, required this.afterDate});
  @override
  _DateRangeSectionState createState() => _DateRangeSectionState();
}

class _DateRangeSectionState extends State<DateRangeSection> {
  DateTime _selectedDate = DateTime.now().startOfCurrentWeek();

  void _updateDate(bool isForward) {
    setState(() {
      _selectedDate = isForward
          ? _selectedDate.add(const Duration(days: 7))
          : _selectedDate.subtract(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = _selectedDate;
    DateTime endDate = _selectedDate.add(const Duration(days: 6));
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
