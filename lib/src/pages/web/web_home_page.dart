import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/entity/calendar_settings.dart';
import 'package:teacher_mate/src/pages/web/create_lesson_dialog.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';

class WebHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final void Function({required String id}) deleteLesson;

  const WebHomePage(
      {super.key, required this.deleteLesson, required this.scaffoldKey});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> widthAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    widthAnimation = Tween<double>(
      begin: _minPanelWidth,
      end: _maxPanelWidth,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      setState(() {
        _panelWidth = widthAnimation.value;
      });
    });
  }

  double _panelWidth = 0.0;
  final double _maxPanelWidth = 400.0;
  final double _minPanelWidth = 0.0;
  final double _fadeThreshold = 200.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _panelWidth -= details.delta.dx;
      if (_panelWidth < _minPanelWidth) {
        _panelWidth = _minPanelWidth;
      } else if (_panelWidth > _maxPanelWidth) {
        _panelWidth = _maxPanelWidth;
      }
    });
  }

  void _togglePanel() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Calendar(
                                    createLesson: createLessonDialog,
                                    minutesGrid: settings.minutesGrid,
                                    startHour: settings.startDay,
                                    endHour: settings.endDay,
                                    viewDay: settings.viewDays,
                                    lessons: state.mapLessons,
                                    deleteLesson: widget.deleteLesson,
                                    student: stateStudent.studentEntity,
                                    startOfWeek: settings.week),
                              ),
                            ),
                          ),
                    GestureDetector(
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      onTap: _togglePanel,
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            double fadeValue = 1.0;
                            if (_panelWidth < _fadeThreshold) {
                              fadeValue = (_panelWidth - _minPanelWidth - 100) /
                                  (_fadeThreshold - _minPanelWidth);
                            }
                            return Row(
                              children: [
                                Center(
                                  child: Container(
                                    width: 12,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                  height: double.infinity,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                FadeTransition(
                                  opacity: AlwaysStoppedAnimation(fadeValue),
                                  child: Container(
                                    width: _panelWidth,
                                    height: double.infinity,
                                    color: Colors.white,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 55,
                                          ),
                                          Text(
                                            'List of students',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Expanded(child: StudentListWidget()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
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
