import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';
import 'package:teacher_mate/src/widgets/shared/text_form_field_widget.dart';
import 'package:teacher_mate/src/widgets/shared/time_widget.dart';

void createLessonDialog(
    {required BuildContext context,
    required DateTime initialStartTime,
    required DateTime initialEndTime,
    bool edit = false,
    String description = '',
    int selectedType = 0,
    int studentId = -1,
    int lessonId = -1}) {
  String selectedTimeStart = DateFormat('HH:mm').format(initialStartTime);
  String selectedTimeEnd = DateFormat('HH:mm').format(initialEndTime);
  int start = initialStartTime.millisecondsSinceEpoch;
  int end = initialEndTime.millisecondsSinceEpoch;

  bool isValid = true;
  int selectedType = 1;
  String description = '';
  int studentId = -1;

  void selectStudent(int id) {
    studentId = id;
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    const DividerTitleWidget(title: 'Lesson time'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
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
                                selectedTimeStart = DateFormat('HH:mm').format(
                                    initialStartTime.copyWith(
                                        hour: picked.hour,
                                        minute: picked.minute));
                                start = initialStartTime
                                    .copyWith(
                                        hour: picked.hour,
                                        minute: picked.minute)
                                    .millisecondsSinceEpoch;
                                isValid = true;
                                if (start >= end) {
                                  isValid = false;
                                }
                              });
                            }
                          },
                          child: TimeWidget(
                              helperText: 'Start time:',
                              selectedTimeEnd: selectedTimeStart,
                              isValid: isValid),
                        ),
                        const SizedBox(
                          height: 60,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: VerticalDivider(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
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
                                selectedTimeEnd = DateFormat('HH:mm').format(
                                    initialEndTime.copyWith(
                                        hour: picked.hour,
                                        minute: picked.minute));
                                end = initialEndTime
                                    .copyWith(
                                        hour: picked.hour,
                                        minute: picked.minute)
                                    .millisecondsSinceEpoch;
                                isValid = true;
                                if (start >= end) {
                                  isValid = false;
                                }
                              });
                            }
                          },
                          child: TimeWidget(
                              helperText: 'End time:',
                              selectedTimeEnd: selectedTimeEnd,
                              isValid: isValid),
                        ),
                      ],
                    ),
                    const DividerTitleWidget(title: 'The color of the lesson'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(ColorType.values.length, (index) {
                        final colorType = ColorType.values[index].value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = colorType;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              shape: BoxShape.circle,
                              color: ColorType.values[index].color,
                            ),
                            width: 30,
                            height: 30,
                            child: selectedType == colorType
                                ? Center(
                                    child: Icon(
                                    Icons.check,
                                    color:
                                        ColorType.values[index].color.shade900,
                                  ))
                                : null,
                          ),
                        );
                      }),
                    ),
                    const DividerTitleWidget(
                      title: 'List of students',
                      height: 16,
                    ),
                    StudentListWidget(
                      height: 200,
                      // width: 400,
                      selectStudent: selectStudent,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const DividerTitleWidget(
                      title: 'Description',
                      height: 16,
                    ),
                    TextFormFieldWidget(
                      onChange: (text) => description = text,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isValid) {
                            context.read<LessonBloc>().add(LessonEvent.create(
                                start: start,
                                end: end,
                                type: selectedType,
                                studentId: studentId,
                                description: description));
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
