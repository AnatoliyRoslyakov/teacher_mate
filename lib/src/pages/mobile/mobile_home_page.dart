import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/config_bloc/config_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/entity/calendar_settings.dart';
import 'package:teacher_mate/src/router/app_router.dart';

class MobileHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final void Function({required String id}) deleteLesson;

  const MobileHomePage(
      {super.key, required this.deleteLesson, required this.scaffoldKey});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage>
    with SingleTickerProviderStateMixin {
  void createLessonPage(
    BuildContext context,
    DateTime initialStartTime,
    DateTime initialEndTime,
  ) {
    context.push(MobileRoutes.create.path, extra: {
      'initialStartTime': initialStartTime,
      'initialEndTime': initialEndTime
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
                                  deleteLesson: widget.deleteLesson,
                                  student: stateStudent.studentEntity,
                                  startOfWeek: settings.week),
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
