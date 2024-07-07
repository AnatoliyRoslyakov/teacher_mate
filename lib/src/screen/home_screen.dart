import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/pages/mobile/mobile_home_page.dart';
import 'package:teacher_mate/src/pages/web/web_home_page.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          ? WebHomePage(
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            )
          : MobileHomePage(
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            ),
    );
  }
}
