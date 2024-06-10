import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/widgets/calendar_base_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//      return const CalendarBaseWidget();
//     // return DraggablePanel();
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _panelWidth = 300.0;
  double _maxPanelWidth = 300.0;
  double _minPanelWidth = 0.0;

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void addLesson(
      {required int start,
      required int end,
      required int type,
      required int studentId}) {
    context
        .read<CalendarBloc>()
        .add(CalendarEvent.create(start, end, type, studentId));
  }

  void deleteLesson({required String id}) {
    context.read<CalendarBloc>().add(CalendarEvent.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return BlocBuilder<StudentBloc, StudentState>(
          builder: (context, stateStudent) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: CalendarSettingsWidget(
              calendarSettings: state.calendarSettings,
            ),
            backgroundColor: Colors.white,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        flex: 2,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Calendar(
                                minutesGrid: state.calendarSettings.minutesGrid,
                                startHour: state.calendarSettings.startHour,
                                endHour: state.calendarSettings.endHour,
                                viewDay: state.calendarSettings.viewDay,
                                lessons: state.mapLessons,
                                addLesson: addLesson,
                                deleteLesson: deleteLesson,
                                student: stateStudent.studentEntity,
                                // если true -> viewDay = 7 (начало: понедельник)
                                startOfWeek:
                                    state.calendarSettings.startOfWeek),
                          ),
                        ),
                      ),
                GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  child: Row(
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
                            padding: const EdgeInsets.all(4.0),
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
                      Container(
                        width: _panelWidth,
                        height: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: stateStudent.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 55,
                                    ),
                                    const Text(
                                      'List of students',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount:
                                          stateStudent.studentEntity.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.amber),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(stateStudent
                                                    .studentEntity[i].name),
                                                Text(
                                                    'price: ${stateStudent.studentEntity[i].price}р'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          overlayColor: Colors.amber,
                                        ),
                                        onPressed: () {
                                          showBlurredDialog(context);
                                        },
                                        child: const Icon(Icons.add))
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(Icons.settings),
            ),
          ),
        );
      });
    });
  }
}
