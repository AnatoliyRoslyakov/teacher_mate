import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showBlurredDialog(
  BuildContext context,
  DateTime initialStartTime,
  DateTime initialEndTime,
  final void Function({required int start, required int end}) onTap,
) {
  final TextEditingController textController = TextEditingController();

  String selectedTimeStart =
      'Начальное время: \n ${DateFormat('HH:mm').format(initialStartTime)}';
  String selectedTimeEnd =
      'Время окончания: \n ${DateFormat('HH:mm').format(initialEndTime)}';

  bool isValid = true;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      int start = initialStartTime.millisecondsSinceEpoch;
      int end = initialEndTime.millisecondsSinceEpoch;
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetAnimationCurve: Curves.linear,
            insetAnimationDuration: const Duration(milliseconds: 500),
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
                        decoration: const InputDecoration(
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
                              selectedTimeStart =
                                  'Начальное время: \n ${DateFormat('HH:mm').format(initialStartTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                              start = initialStartTime
                                  .copyWith(
                                      hour: picked.hour, minute: picked.minute)
                                  .millisecondsSinceEpoch;
                              isValid = true;
                              if (start >= end) {
                                isValid = false;
                              }
                            });
                          }
                        },
                        child: Text(
                          selectedTimeStart,
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.red),
                          textAlign: TextAlign.center,
                        ),
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
                              selectedTimeEnd =
                                  'Время окончания: \n ${DateFormat('HH:mm').format(initialEndTime.copyWith(hour: picked.hour, minute: picked.minute))}';
                              end = initialEndTime
                                  .copyWith(
                                      hour: picked.hour, minute: picked.minute)
                                  .millisecondsSinceEpoch;
                              isValid = true;
                              if (start >= end) {
                                isValid = false;
                              }
                            });
                          }
                        },
                        child: Text(
                          selectedTimeEnd,
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (isValid) {
                            onTap.call(start: start, end: end);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.grey),
                        ),
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
