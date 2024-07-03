import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/pages/mobile/mobile_home_content.dart';
import 'package:teacher_mate/src/pages/web/web_home_content.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CalendarSettingsWidget(),
      backgroundColor: Colors.white,
      // виджеты -- сила, в зависимости от платформы будет меняться только компановка
      body: kIsWeb
          ? WebHomeContent(
              addLesson: addLesson,
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            )
          : MobileHomeContent(
              addLesson: addLesson,
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            ),
    );
  }
}
