import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/pages/web/create_lesson_dialog.dart';
import 'package:teacher_mate/src/widgets/web/toggle_panel_widget.dart';

class WebHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WebHomePage({super.key, required this.scaffoldKey});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(builder: (context, state) {
      return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settings) {
        return BlocBuilder<StudentBloc, StudentState>(
            builder: (context, stateStudent) {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Stack(
              children: [
                Positioned(
                    top: 20,
                    left: 15,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              widget.scaffoldKey.currentState?.openDrawer();
                            },
                            icon: const Icon(Icons.menu)),
                        const SizedBox(
                          width: 20,
                        ),
                        RichText(
                            textDirection: TextDirection.ltr,
                            text: const TextSpan(
                              text: 'Teacher',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Mate',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ))
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Calendar(
                                    threeDays: settings.three,
                                    createLesson: createLessonDialog,
                                    minutesGrid: settings.minutesGrid,
                                    startHour: settings.startDay,
                                    endHour: settings.endDay,
                                    viewDay: settings.viewDays,
                                    lessons: state.mapLessons,
                                    student: stateStudent.studentEntity,
                                    startOfWeek: settings.week),
                              ),
                            ),
                          ),
                    const TogglePanelWidget()
                  ],
                ),
              ],
            ),
          );
        });
      });
    });
  }
}
