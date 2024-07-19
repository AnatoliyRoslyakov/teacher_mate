import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';
import 'package:teacher_mate/src/widgets/shared/text_form_field_widget.dart';
import 'package:teacher_mate/src/widgets/shared/time_widget.dart';

class CreateLessonPage extends StatefulWidget {
  final DateTime initialStartTime;
  final DateTime initialEndTime;
  const CreateLessonPage(
      {super.key,
      required this.initialStartTime,
      required this.initialEndTime});

  @override
  State<CreateLessonPage> createState() => _CreateLessonPageState();
}

class _CreateLessonPageState extends State<CreateLessonPage> {
  bool isValid = true;
  String selectedTimeStart = '';
  String selectedTimeEnd = '';
  int start = 0;
  int end = 0;
  int selectedType = 1;
  int studentId = -1;
  String description = '';

  void selectStudent(int id) {
    studentId = id;
  }

  @override
  void initState() {
    selectedTimeStart = DateFormat('HH:mm').format(widget.initialStartTime);
    selectedTimeEnd = DateFormat('HH:mm').format(widget.initialEndTime);
    start = widget.initialStartTime.millisecondsSinceEpoch;
    end = widget.initialEndTime.millisecondsSinceEpoch;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        hour: widget.initialStartTime.hour,
                        minute: widget.initialStartTime.minute),
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
                      selectedTimeStart = DateFormat('HH:mm').format(widget
                          .initialStartTime
                          .copyWith(hour: picked.hour, minute: picked.minute));
                      start = widget.initialStartTime
                          .copyWith(hour: picked.hour, minute: picked.minute)
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
                        hour: widget.initialEndTime.hour,
                        minute: widget.initialEndTime.minute),
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
                      selectedTimeEnd = DateFormat('HH:mm').format(widget
                          .initialEndTime
                          .copyWith(hour: picked.hour, minute: picked.minute));
                      end = widget.initialEndTime
                          .copyWith(hour: picked.hour, minute: picked.minute)
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
                          color: ColorType.values[index].color.shade900,
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
            width: 400,
            selectStudent: selectStudent,
          ),
          const SizedBox(
            height: 8,
          ),
          const DividerTitleWidget(
            title: 'Description',
            height: 16,
          ),
          const TextFormFieldWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                if (isValid) {
                  context.read<LessonBloc>().add(LessonEvent.create(
                      start, end, selectedType, studentId, description));
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style:
                    TextStyle(color: isValid ? Colors.deepPurple : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
