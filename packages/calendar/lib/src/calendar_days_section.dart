import 'package:calendar/calendar.dart';
import 'package:calendar/src/calendar_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDaysSection extends StatelessWidget {
  const CalendarDaysSection({
    super.key,
    required this.widget,
    required this.viewDay,
    required this.startTime,
  });

  final Calendar widget;
  final int viewDay;
  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat('MMM').format(startTime.add(Duration(days: viewDay)));
    return widget.mobile
        ? Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Text(
                  textAlign: TextAlign.center,
                  time,
                  style: CalendarTextStyle.b3,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(children: [
                      ...List.generate(
                          widget.startOfWeek ? viewDay : widget.viewDay,
                          (index) {
                        final time = DateFormat('E')
                            .format(startTime.add(Duration(days: index)));
                        return Expanded(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                time,
                                style: CalendarTextStyle.b3,
                              ),
                            ),
                          ),
                        ));
                      }),
                    ]),
                    const Divider(),
                    Row(children: [
                      ...List.generate(
                          widget.startOfWeek ? viewDay : widget.viewDay,
                          (index) {
                        final time = DateFormat('d')
                            .format(startTime.add(Duration(days: index)));
                        final current =
                            startTime.add(Duration(days: index)).startOfDay() ==
                                DateTime.now().startOfDay();

                        return current
                            ? Expanded(
                                child: Center(
                                    child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          time,
                                          style: CalendarTextStyle.b5
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    )),
                              )))
                            : Expanded(
                                child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      time,
                                      style: CalendarTextStyle.b5,
                                    ),
                                  ),
                                ),
                              ));
                      }),
                    ]),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          )
        : Row(children: [
            const SizedBox(
              height: 60,
              width: 60,
            ),
            ...List.generate(widget.startOfWeek ? viewDay : widget.viewDay,
                (index) {
              final time = DateFormat(widget.viewDay > 10 || widget.mobile
                      ? 'E\ndd.MM'
                      : 'E dd.MM')
                  .format(startTime.add(Duration(days: index)));
              final current =
                  startTime.add(Duration(days: index)).startOfDay() ==
                      DateTime.now().startOfDay();

              return current
                  ? Expanded(
                      child: Center(
                          child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                time,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    )))
                  : Expanded(
                      child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            time,
                          ),
                        ),
                      ),
                    ));
            }),
          ]);
  }
}
