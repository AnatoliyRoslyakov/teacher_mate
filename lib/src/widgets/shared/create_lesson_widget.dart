import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/widgets/shared/app_button.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';
import 'package:teacher_mate/src/widgets/shared/text_form_field_widget.dart';
import 'package:teacher_mate/src/widgets/shared/time_widget.dart';

class CreateLessonWidget extends StatefulWidget {
  final DateTime initialStartTime;
  final DateTime initialEndTime;
  final bool edit;
  final String description;
  final int selectedType;
  final int studentId;
  final int lessonId;
  final bool mobile;
  const CreateLessonWidget(
      {super.key,
      required this.initialStartTime,
      required this.initialEndTime,
      required this.edit,
      required this.description,
      required this.selectedType,
      required this.studentId,
      required this.lessonId,
      this.mobile = false});

  @override
  State<CreateLessonWidget> createState() => _CreateLessonWidgetState();
}

class _CreateLessonWidgetState extends State<CreateLessonWidget> {
  bool isValid = true;
  late String selectedTimeStart;
  late String selectedTimeEnd;
  late int start;
  late int end;
  late int selectedType;
  late int studentId;
  late String description;
  late int lessonId;

  void selectStudent(int id) {
    studentId = id;
  }

  @override
  void initState() {
    selectedTimeStart = DateFormat('HH:mm').format(widget.initialStartTime);
    selectedTimeEnd = DateFormat('HH:mm').format(widget.initialEndTime);
    start = widget.initialStartTime.millisecondsSinceEpoch;
    end = widget.initialEndTime.millisecondsSinceEpoch;
    description = widget.description;
    selectedType = widget.selectedType;
    studentId = widget.studentId;
    lessonId = widget.lessonId;

    super.initState();
  }

  bool customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
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
                            selectedTimeStart = DateFormat('HH:mm').format(
                                widget.initialStartTime.copyWith(
                                    hour: picked.hour, minute: picked.minute));
                            start = widget.initialStartTime
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
                            selectedTimeEnd = DateFormat('HH:mm').format(
                                widget.initialEndTime.copyWith(
                                    hour: picked.hour, minute: picked.minute));
                            end = widget.initialEndTime
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
                  mobile: widget.mobile,
                  height: 200,
                  width: 400,
                  selectStudent: selectStudent,
                  studentId: studentId,
                ),
                const SizedBox(
                  height: 16,
                ),
                // const Divider(),
                DecoratedBox(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black12))),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      enableFeedback: true,
                      dense: true,
                      tilePadding: EdgeInsets.zero,
                      title: const Text(
                        'Description',
                        style: TextStyle(fontSize: 14),
                      ),
                      children: [
                        TextFormFieldWidget(
                          lines: (5, 20),
                          hintText: 'Lesson plan',
                          initValue: description,
                          onChange: (text) => description = text,
                        )
                      ],
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          customTileExpanded = expanded;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                // flex: 3,
                child: AppButton.base(
                  label: widget.edit ? 'Edit' : 'Save',
                  onTap: isValid
                      ? () {
                          widget.edit
                              ? context.read<LessonBloc>().add(
                                  LessonEvent.update(
                                      id: lessonId,
                                      start: start,
                                      end: end,
                                      type: selectedType,
                                      studentId: studentId,
                                      description: description))
                              : context.read<LessonBloc>().add(
                                  LessonEvent.create(
                                      start: start,
                                      end: end,
                                      type: selectedType,
                                      studentId: studentId,
                                      description: description));
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ),
              widget.edit
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox.shrink(),
              widget.edit
                  ? AppButton.icon(
                      backgroundColor: Colors.transparent,
                      icon: Icons.delete,
                      iconColor: Colors.red,
                      onTap: () {
                        context
                            .read<LessonBloc>()
                            .add(LessonEvent.delete(lessonId));

                        Navigator.of(context).pop();
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
