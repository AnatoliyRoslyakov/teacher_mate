import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/config_bloc/config_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/router/app_router.dart';

class MobileHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MobileHomePage({super.key, required this.scaffoldKey});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage>
    with SingleTickerProviderStateMixin {
  void createLessonPage(
      {required BuildContext context,
      required DateTime initialStartTime,
      required DateTime initialEndTime,
      bool edit = false,
      String description = '',
      int selectedType = 0,
      int studentId = -1,
      int lessonId = -1}) {
    context.push(MobileRoutes.create.path, extra: {
      'initialStartTime': initialStartTime,
      'initialEndTime': initialEndTime,
      'edit': edit,
      'description': description,
      'selectedType': selectedType,
      'studentId': studentId,
      'lessonId': lessonId
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc, ConfigState>(
      listener: (context, state) {},
      child: BlocBuilder<LessonBloc, LessonState>(builder: (context, state) {
        return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settings) {
          return BlocBuilder<StudentBloc, StudentState>(
              builder: (context, stateStudent) {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                          onPressed: () {
                            widget.scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Expanded(
                              child: Calendar(
                                  createLesson: createLessonPage,
                                  mobile: true,
                                  minutesGrid: settings.minutesGrid,
                                  startHour: settings.startDay,
                                  endHour: settings.endDay,
                                  viewDay: settings.viewDays,
                                  lessons: state.mapLessons,
                                  student: stateStudent.studentEntity,
                                  startOfWeek: settings.week,
                                  threeDays: settings.three),
                            ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
      }),
    );
  }
}
