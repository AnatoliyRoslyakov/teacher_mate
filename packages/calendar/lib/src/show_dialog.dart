import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showBlurredDialog(
  BuildContext context,
  DateTime initialStartTime,
  DateTime initialEndTime,
  final List<StudentEntity> student,
  final void Function(
          {required int start,
          required int end,
          required int type,
          required int studentId})
      onTap,
) {
  String selectedTimeStart =
      'Начальное время: \n ${DateFormat('HH:mm').format(initialStartTime)}';
  String selectedTimeEnd =
      'Время окончания: \n ${DateFormat('HH:mm').format(initialEndTime)}';

  bool isValid = true;
  int selectedType = 1;
  int studentId = -1;

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
                      Text('Create a lesson', style: TextStyle(fontSize: 24)),
                      Row(
                        children:
                            List.generate(ColorType.values.length, (index) {
                          final colorType = ColorType.values[index].value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = colorType;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorType.values[index].color,
                                border: selectedType == colorType
                                    ? Border.all(
                                        color: Colors.amber, width: 5.0)
                                    : null,
                              ),
                              width: 40,
                              height: 40,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'List of students',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3 - 42,
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemCount: student.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  hoverColor: Colors.amber,
                                  onTap: () {
                                    setState(() {
                                      studentId = student[i].id;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: studentId == student[i].id
                                            ? Colors.amber
                                            : Colors.amber.withOpacity(0.3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(student[i].name),
                                          Text('price: ${student[i].price}р'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  overlayColor: Colors.amber,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width / 3 -
                                          42,
                                      45)),
                              onPressed: () {
                                // прокинуть воид колбэк
                                // showBlurredDialog(context);
                              },
                              child: const Icon(Icons.add))
                        ],
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
                                  'Start time: \n ${DateFormat('HH:mm').format(initialStartTime.copyWith(hour: picked.hour, minute: picked.minute))}';
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
                                  'End time: \n ${DateFormat('HH:mm').format(initialEndTime.copyWith(hour: picked.hour, minute: picked.minute))}';
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
                            onTap.call(
                                start: start,
                                end: end,
                                type: selectedType,
                                studentId: studentId);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Save',
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
